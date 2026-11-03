import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:phone_state/phone_state.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/repositories/busy_status_repository_impl.dart';
import '../../data/repositories/call_log_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/whitelist_repository_impl.dart';
import '../../domain/usecases/format_reply_message_usecase.dart';
import '../../domain/usecases/match_busy_status_usecase.dart';
import '../../domain/usecases/process_incoming_call_usecase.dart';
import '../../domain/usecases/should_send_reply_usecase.dart';
import '../utils/time_utils.dart';
import 'contacts_service.dart';
import 'native_sms_service.dart';
import 'notification_service.dart';

class BackgroundServiceManager {
  static final BackgroundServiceManager _instance =
      BackgroundServiceManager._internal();
  factory BackgroundServiceManager() => _instance;
  BackgroundServiceManager._internal();

  final FlutterBackgroundService _service = FlutterBackgroundService();

  Future<void> initialize() async {
    try {
      await NotificationService().init();

      await _service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false, // Do not auto-start before permissions are granted
          isForegroundMode: true,
          notificationChannelId: NotificationService.channelIdForeground,
          initialNotificationTitle: 'Busy Auto-Reply',
          initialNotificationContent: 'Monitoring incoming calls',
          foregroundServiceNotificationId: 888,
          foregroundServiceTypes: [
            AndroidForegroundType.specialUse,
          ],
        ),
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
      );
    } catch (e) {
      debugPrint('Error configuring background service: $e');
    }
  }

  Future<bool> isRunning() async {
    try {
      return await _service.isRunning();
    } catch (_) {
      return false;
    }
  }

  Future<void> start() async {
    try {
      final running = await _service.isRunning();
      if (!running) {
        await _service.startService();
      }
    } catch (e) {
      debugPrint('Error starting background service: $e');
    }
  }

  Future<void> stop() async {
    try {
      _service.invoke('stopService');
    } catch (_) {}
  }

  void updateStatusNow() {
    try {
      _service.invoke('refreshStatus');
    } catch (_) {}
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    try {
      DartPluginRegistrant.ensureInitialized();
    } catch (_) {}
    WidgetsFlutterBinding.ensureInitialized();

    final db = AppDatabase();
    final statusRepo = BusyStatusRepositoryImpl(db);
    final logRepo = CallLogRepositoryImpl(db);
    final whitelistRepo = WhitelistRepositoryImpl(db);
    final settingsRepo = SettingsRepositoryImpl();
    final contactsService = ContactsService();
    final smsService = NativeSmsService(serviceInstance: service);
    final matchUseCase = MatchBusyStatusUseCase();
    final formatUseCase = FormatReplyMessageUseCase();
    final shouldSendUseCase = ShouldSendReplyUseCase();

    final processIncomingCallUseCase = ProcessIncomingCallUseCase(
      statusRepo: statusRepo,
      logRepo: logRepo,
      whitelistRepo: whitelistRepo,
      settingsRepo: settingsRepo,
      contactsService: contactsService,
      smsService: smsService,
      matchBusyStatusUseCase: matchUseCase,
      formatReplyMessageUseCase: formatUseCase,
      shouldSendReplyUseCase: shouldSendUseCase,
    );

    // Function to refresh persistent notification content
    Future<void> updateNotification() async {
      try {
        final now = DateTime.now();
        final settings = await settingsRepo.getSettings();
        if (!settings.isMasterEnabled) {
          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
              title: 'Busy Auto-Reply (Paused)',
              content: 'Master auto-reply switch is turned OFF',
            );
          }
          return;
        }

        final allStatuses = await statusRepo.getAllStatuses();
        final activeStatus = matchUseCase.execute(
          allStatuses: allStatuses,
          currentTime: now,
        );

        if (activeStatus != null) {
          final isBn = settings.language == 'bn';
          final returnTimeStr = TimeUtils.formatMinutesTo12Hour(
            activeStatus.endMinutes,
            isBangla: isBn,
          );
          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
              title: 'Busy: ${activeStatus.title}',
              content: isBn
                  ? 'ইনকামিং কল পর্যবেক্ষণ করা হচ্ছে (ফেরার সময়: $returnTimeStr)'
                  : 'Auto-reply active until $returnTimeStr',
            );
          }
        } else {
          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
              title: 'Busy Auto-Reply (Standby)',
              content:
                  'Monitoring incoming calls. No busy status active right now.',
            );
          }
        }
      } catch (e) {
        debugPrint('Error updating notification: $e');
      }
    }

    // Initial update
    await updateNotification();

    // Periodic timer to keep notification up-to-date and clean quick toggles
    Timer.periodic(const Duration(seconds: 45), (timer) async {
      await updateNotification();
    });

    // Track the last handled call to avoid duplicate triggers within a few seconds
    String? lastProcessedNumber;
    DateTime? lastProcessedTime;

    // Handler for cellular incoming calls
    void handleCellularCall(String incomingNumber) async {
      final cleanNumber = incomingNumber.trim();
      if (cleanNumber.isEmpty) return;

      final now = DateTime.now();

      // Debounce same call event within 8 seconds
      if (lastProcessedNumber == cleanNumber &&
          lastProcessedTime != null &&
          now.difference(lastProcessedTime!).inSeconds < 8) {
        return;
      }

      lastProcessedNumber = cleanNumber;
      lastProcessedTime = now;

      debugPrint('Background service processing cellular call: $cleanNumber');

      await processIncomingCallUseCase.execute(
        rawCallerNumber: cleanNumber,
        callTimestamp: now,
        callSource: 'cellular',
      );

      await updateNotification();
    }

    // 1. Listen via flutter_background_service pipe from native PhoneCallReceiver
    service.on('phone_call').listen((event) {
      if (event != null) {
        final number = event['phoneNumber'] as String?;
        if (number != null && number.isNotEmpty) {
          handleCellularCall(number);
        }
      }
    });

    // 2. Listen to PhoneState stream for incoming calls as redundant backup
    try {
      PhoneState.stream.listen((event) async {
        if (event.status == PhoneStateStatus.CALL_INCOMING) {
          final incomingNumber = event.number;
          if (incomingNumber != null && incomingNumber.isNotEmpty) {
            handleCellularCall(incomingNumber);
          }
        }
      });
    } catch (e) {
      debugPrint('Error listening to PhoneState stream: $e');
    }

    // Track last handled VoIP call
    String? lastVoipDebounceKey;
    DateTime? lastVoipProcessedTime;

    void handleVoipCall(Map<String, dynamic> event) async {
      final source = event['source'] as String? ?? 'unknown';
      final callerName = event['callerName'] as String? ?? '';
      final notificationKey = event['notificationKey'] as String?;
      final hasDirectReply = event['hasDirectReply'] as bool? ?? false;
      final phoneNumber = event['phoneNumber'] as String?;

      if (callerName.isEmpty) return;

      final now = DateTime.now();
      final debounceKey = '$source:$callerName';
      if (lastVoipDebounceKey == debounceKey &&
          lastVoipProcessedTime != null &&
          now.difference(lastVoipProcessedTime!).inSeconds < 12) {
        return;
      }
      lastVoipDebounceKey = debounceKey;
      lastVoipProcessedTime = now;

      debugPrint(
          'Background service processing VoIP call: $source - $callerName (phone: $phoneNumber, directReply: $hasDirectReply)');

      await processIncomingCallUseCase.execute(
        rawCallerNumber: callerName,
        callTimestamp: now,
        callSource: source,
        notificationKey: notificationKey,
        hasDirectReply: hasDirectReply,
        voipPhoneNumber: phoneNumber,
      );

      await updateNotification();
    }

    // Listen to VoIP calls via flutter_background_service pipe
    service.on('voip_call').listen((event) {
      if (event != null) {
        handleVoipCall(Map<String, dynamic>.from(event));
      }
    });

    // Service control events
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    service.on('refreshStatus').listen((event) async {
      await updateNotification();
    });
  } catch (e, st) {
    debugPrint('Fatal error in background service onStart: $e\n$st');
  }
}
