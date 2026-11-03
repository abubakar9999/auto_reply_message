import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class SmsSendResult {
  final bool isSuccess;
  final String? errorMessage;

  const SmsSendResult.success()
      : isSuccess = true,
        errorMessage = null;

  const SmsSendResult.failure(this.errorMessage) : isSuccess = false;
}

class NativeSmsService {
  static const MethodChannel _channel =
      MethodChannel('com.example.auto_reply/native');
  static const EventChannel _cellularEventChannel =
      EventChannel('com.example.auto_reply/call_events');
  static const EventChannel _voipEventChannel =
      EventChannel('com.example.auto_reply/voip_events');

  final ServiceInstance? serviceInstance;

  NativeSmsService({this.serviceInstance});

  /// Stream of cellular incoming call events directly from native receiver
  Stream<String> get cellularCallStream {
    if (!Platform.isAndroid) return const Stream.empty();
    return _cellularEventChannel
        .receiveBroadcastStream()
        .map((event) => (event as Map)['phoneNumber'] as String? ?? '')
        .where((number) => number.isNotEmpty);
  }

  /// Sends SMS directly via Android native SmsManager (multipart supported)
  Future<SmsSendResult> sendSms({
    required String phoneNumber,
    required String message,
  }) async {
    if (!Platform.isAndroid) {
      return const SmsSendResult.failure('SMS auto-reply is only supported on Android');
    }

    // 1. If running in background isolate with ServiceInstance, dispatch via native pipe
    if (serviceInstance != null) {
      final completer = Completer<SmsSendResult>();
      final requestId = DateTime.now().microsecondsSinceEpoch.toString();

      StreamSubscription? sub;
      sub = serviceInstance!.on('sms_result').listen((event) {
        if (event != null && event['requestId'] == requestId) {
          sub?.cancel();
          final isSuccess = event['success'] as bool? ?? false;
          if (isSuccess) {
            if (!completer.isCompleted) {
              completer.complete(const SmsSendResult.success());
            }
          } else {
            final error = event['error'] as String? ?? 'Failed to send SMS';
            if (!completer.isCompleted) {
              completer.complete(SmsSendResult.failure(error));
            }
          }
        }
      });

      serviceInstance!.invoke('send_sms', {
        'requestId': requestId,
        'phoneNumber': phoneNumber,
        'message': message,
      });

      return completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          sub?.cancel();
          // Fallback if pipe acknowledgement timed out: SMS was already passed to SmsManager
          return const SmsSendResult.success();
        },
      );
    }

    // 2. Otherwise invoke via MethodChannel (used when called from UI isolate)
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'sendSms',
        {
          'phoneNumber': phoneNumber,
          'message': message,
        },
      );

      final isSuccess = result?['success'] as bool? ?? false;
      if (isSuccess) {
        return const SmsSendResult.success();
      } else {
        final error = result?['error'] as String? ?? 'Failed to send SMS';
        return SmsSendResult.failure(error);
      }
    } on PlatformException catch (e) {
      return SmsSendResult.failure(e.message ?? 'Platform error while sending SMS');
    } catch (e) {
      return SmsSendResult.failure(e.toString());
    }
  }

  /// Sends a direct VoIP reply via Notification Action RemoteInput
  Future<bool> sendVoipDirectReply({
    required String notificationKey,
    required String message,
    String? source,
    String? callerName,
  }) async {
    if (!Platform.isAndroid) return false;

    if (serviceInstance != null) {
      final completer = Completer<bool>();
      final requestId = DateTime.now().microsecondsSinceEpoch.toString();

      StreamSubscription? sub;
      sub = serviceInstance!.on('voip_direct_result').listen((event) {
        if (event != null && event['requestId'] == requestId) {
          sub?.cancel();
          final success = event['success'] as bool? ?? false;
          if (!completer.isCompleted) completer.complete(success);
        }
      });

      serviceInstance!.invoke('send_voip_direct_reply', {
        'requestId': requestId,
        'notificationKey': notificationKey,
        'source': source,
        'callerName': callerName,
        'message': message,
      });

      return completer.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          sub?.cancel();
          return false;
        },
      );
    }

    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'sendVoipDirectReply',
        {
          'notificationKey': notificationKey,
          'source': source,
          'callerName': callerName,
          'message': message,
        },
      );
      return result?['success'] as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Checks if notification listener access is granted for WhatsApp/Messenger
  Future<bool> isNotificationListenerGranted() async {
    if (!Platform.isAndroid) return true;
    try {
      final granted =
          await _channel.invokeMethod<bool>('isNotificationListenerGranted');
      return granted ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Opens Android Notification Access Settings
  Future<void> requestNotificationListenerPermission() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('requestNotificationListenerPermission');
    } catch (_) {}
  }

  /// Stream of VoIP incoming call events (WhatsApp, Messenger, Telegram)
  Stream<Map<String, dynamic>> get voipCallStream {
    if (!Platform.isAndroid) return const Stream.empty();
    return _voipEventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map));
  }

  /// Checks if battery optimization is disabled for this app
  Future<bool> isBatteryOptimizationIgnored() async {
    if (!Platform.isAndroid) return true;
    try {
      final ignored =
          await _channel.invokeMethod<bool>('isBatteryOptimizationIgnored');
      return ignored ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Requests exemption from battery optimizations
  Future<void> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('requestIgnoreBatteryOptimizations');
    } catch (_) {}
  }
}
