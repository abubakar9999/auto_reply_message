import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/services/native_sms_service.dart';

class PermissionStatusState {
  final bool phone;
  final bool sms;
  final bool contacts;
  final bool notifications;
  final bool batteryOptimizationIgnored;
  final bool notificationListenerGranted;

  const PermissionStatusState({
    this.phone = false,
    this.sms = false,
    this.contacts = false,
    this.notifications = false,
    this.batteryOptimizationIgnored = false,
    this.notificationListenerGranted = false,
  });

  bool get isCoreGranted => phone && sms;

  bool get isAllGranted =>
      phone &&
      sms &&
      contacts &&
      notifications &&
      batteryOptimizationIgnored &&
      notificationListenerGranted;

  PermissionStatusState copyWith({
    bool? phone,
    bool? sms,
    bool? contacts,
    bool? notifications,
    bool? batteryOptimizationIgnored,
    bool? notificationListenerGranted,
  }) {
    return PermissionStatusState(
      phone: phone ?? this.phone,
      sms: sms ?? this.sms,
      contacts: contacts ?? this.contacts,
      notifications: notifications ?? this.notifications,
      batteryOptimizationIgnored:
          batteryOptimizationIgnored ?? this.batteryOptimizationIgnored,
      notificationListenerGranted:
          notificationListenerGranted ?? this.notificationListenerGranted,
    );
  }
}

class PermissionNotifier extends Notifier<PermissionStatusState> {
  final NativeSmsService _smsService = NativeSmsService();

  @override
  PermissionStatusState build() {
    checkAll();
    return const PermissionStatusState();
  }

  Future<void> checkAll() async {
    if (!Platform.isAndroid) {
      state = const PermissionStatusState(
        phone: true,
        sms: true,
        contacts: true,
        notifications: true,
        batteryOptimizationIgnored: true,
        notificationListenerGranted: true,
      );
      return;
    }

    final phoneStatus = await Permission.phone.isGranted;
    final smsStatus = await Permission.sms.isGranted;
    final contactsStatus = await Permission.contacts.isGranted;
    final notificationStatus = await Permission.notification.isGranted;
    final batteryIgnored = await _smsService.isBatteryOptimizationIgnored();
    final notifListenerGranted =
        await _smsService.isNotificationListenerGranted();

    state = PermissionStatusState(
      phone: phoneStatus,
      sms: smsStatus,
      contacts: contactsStatus,
      notifications: notificationStatus,
      batteryOptimizationIgnored: batteryIgnored,
      notificationListenerGranted: notifListenerGranted,
    );
  }

  Future<void> requestPhonePermission() async {
    await Permission.phone.request();
    await checkAll();
  }

  Future<void> requestSmsPermission() async {
    await Permission.sms.request();
    await checkAll();
  }

  Future<void> requestContactsPermission() async {
    await Permission.contacts.request();
    await checkAll();
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
    await checkAll();
  }

  Future<void> requestNotificationListenerPermission() async {
    await _smsService.requestNotificationListenerPermission();
    await checkAll();
  }

  Future<void> requestBatteryExemption() async {
    await _smsService.requestIgnoreBatteryOptimizations();
    await checkAll();
  }

  Future<void> requestAll() async {
    await [
      Permission.phone,
      Permission.sms,
      Permission.contacts,
      Permission.notification,
    ].request();

    await _smsService.requestIgnoreBatteryOptimizations();
    await checkAll();
  }
}

final permissionProvider =
    NotifierProvider<PermissionNotifier, PermissionStatusState>(
        PermissionNotifier.new);
