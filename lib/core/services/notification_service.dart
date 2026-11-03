import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelIdForeground = 'busy_auto_reply_service';
  static const String channelNameForeground = 'Busy Auto-Reply Service';

  static const String channelIdAlerts = 'busy_auto_reply_alerts';
  static const String channelNameAlerts = 'Auto-Reply Alerts';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handled when user taps notification
      },
    );

    // Create notification channels for Android
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelIdForeground,
          channelNameForeground,
          description: 'Keeps Busy Auto-Reply monitoring incoming calls',
          importance: Importance.low,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelIdAlerts,
          channelNameAlerts,
          description: 'Notifies when an automated SMS reply is dispatched',
          importance: Importance.high,
        ),
      );
    }

    _isInitialized = true;
  }

  /// Displays an alert when auto-reply SMS was successfully sent
  Future<void> showAutoReplySentNotification({
    required String callerInfo,
    required String statusTitle,
    required String messageSent,
  }) async {
    await init();
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channelIdAlerts,
      channelNameAlerts,
      channelDescription: 'Alerts for auto-replied SMS',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Auto-Replied to $callerInfo',
      body: '[$statusTitle]: $messageSent',
      notificationDetails: platformDetails,
    );
  }

  /// Displays an alert when a VoIP call (WhatsApp, Messenger) cannot be auto-replied
  /// because the contact is not in the phonebook and has no direct notification reply.
  Future<void> showVoipUnsavedContactAlert({
    required String callerName,
    required String appSource,
    required bool isBangla,
  }) async {
    await init();
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channelIdAlerts,
      channelNameAlerts,
      channelDescription: 'Alerts for auto-replied SMS',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    final title = isBangla
        ? '$callerName থেকে $appSource কল মিস হয়েছে'
        : 'Missed $appSource call from $callerName';
    final body = isBangla
        ? 'কন্টাক্টে নম্বর না থাকায় অটো-রিপ্লাই পাঠানো যায়নি। কলকারীকে ফোনে সেভ করুন।'
        : 'Phone number not in contacts; cannot auto-reply. Save to contacts for SMS reply.';

    await _flutterLocalNotificationsPlugin.show(
      id: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 1,
      title: title,
      body: body,
      notificationDetails: platformDetails,
    );
  }
}

