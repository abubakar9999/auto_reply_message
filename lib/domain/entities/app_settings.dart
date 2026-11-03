class AppSettings {
  final bool isMasterEnabled;
  final String defaultMessage;
  final int cooldownMinutes;
  final bool onlyReplyToContacts;
  final bool skipUnknownNumbers;
  final bool autoRejectCall;
  final int logRetentionDays;
  final String language; // 'en' or 'bn'
  final String themeMode; // 'system', 'light', 'dark'
  final String prayerCity;
  final String prayerCountry;
  final int prayerCalculationMethod;

  // Call source toggles
  final bool enableCellularCalls;
  final bool enableWhatsAppCalls;
  final bool enableMessengerCalls;
  final bool enableTelegramCalls;

  const AppSettings({
    this.isMasterEnabled = true,
    this.defaultMessage = 'Ami {status} a aci, {duration} min por call divo.',
    this.cooldownMinutes = 30,
    this.onlyReplyToContacts = false,
    this.skipUnknownNumbers = true,
    this.autoRejectCall = false,
    this.logRetentionDays = 30,
    this.language = 'bn',
    this.themeMode = 'system',
    this.prayerCity = 'Dhaka',
    this.prayerCountry = 'Bangladesh',
    this.prayerCalculationMethod = 1, // University of Islamic Sciences, Karachi (standard in Bangladesh)
    this.enableCellularCalls = true,
    this.enableWhatsAppCalls = true,
    this.enableMessengerCalls = true,
    this.enableTelegramCalls = true,
  });

  AppSettings copyWith({
    bool? isMasterEnabled,
    String? defaultMessage,
    int? cooldownMinutes,
    bool? onlyReplyToContacts,
    bool? skipUnknownNumbers,
    bool? autoRejectCall,
    int? logRetentionDays,
    String? language,
    String? themeMode,
    String? prayerCity,
    String? prayerCountry,
    int? prayerCalculationMethod,
    bool? enableCellularCalls,
    bool? enableWhatsAppCalls,
    bool? enableMessengerCalls,
    bool? enableTelegramCalls,
  }) {
    return AppSettings(
      isMasterEnabled: isMasterEnabled ?? this.isMasterEnabled,
      defaultMessage: defaultMessage ?? this.defaultMessage,
      cooldownMinutes: cooldownMinutes ?? this.cooldownMinutes,
      onlyReplyToContacts: onlyReplyToContacts ?? this.onlyReplyToContacts,
      skipUnknownNumbers: skipUnknownNumbers ?? this.skipUnknownNumbers,
      autoRejectCall: autoRejectCall ?? this.autoRejectCall,
      logRetentionDays: logRetentionDays ?? this.logRetentionDays,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      prayerCity: prayerCity ?? this.prayerCity,
      prayerCountry: prayerCountry ?? this.prayerCountry,
      prayerCalculationMethod:
          prayerCalculationMethod ?? this.prayerCalculationMethod,
      enableCellularCalls: enableCellularCalls ?? this.enableCellularCalls,
      enableWhatsAppCalls: enableWhatsAppCalls ?? this.enableWhatsAppCalls,
      enableMessengerCalls: enableMessengerCalls ?? this.enableMessengerCalls,
      enableTelegramCalls: enableTelegramCalls ?? this.enableTelegramCalls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isMasterEnabled': isMasterEnabled,
      'defaultMessage': defaultMessage,
      'cooldownMinutes': cooldownMinutes,
      'onlyReplyToContacts': onlyReplyToContacts,
      'skipUnknownNumbers': skipUnknownNumbers,
      'autoRejectCall': autoRejectCall,
      'logRetentionDays': logRetentionDays,
      'language': language,
      'themeMode': themeMode,
      'prayerCity': prayerCity,
      'prayerCountry': prayerCountry,
      'prayerCalculationMethod': prayerCalculationMethod,
      'enableCellularCalls': enableCellularCalls,
      'enableWhatsAppCalls': enableWhatsAppCalls,
      'enableMessengerCalls': enableMessengerCalls,
      'enableTelegramCalls': enableTelegramCalls,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      isMasterEnabled: map['isMasterEnabled'] as bool? ?? true,
      defaultMessage: map['defaultMessage'] as String? ??
          'Ami {status} a aci, {duration} min por call divo.',
      cooldownMinutes: map['cooldownMinutes'] as int? ?? 30,
      onlyReplyToContacts: map['onlyReplyToContacts'] as bool? ?? false,
      skipUnknownNumbers: map['skipUnknownNumbers'] as bool? ?? true,
      autoRejectCall: map['autoRejectCall'] as bool? ?? false,
      logRetentionDays: map['logRetentionDays'] as int? ?? 30,
      language: map['language'] as String? ?? 'bn',
      themeMode: map['themeMode'] as String? ?? 'system',
      prayerCity: map['prayerCity'] as String? ?? 'Dhaka',
      prayerCountry: map['prayerCountry'] as String? ?? 'Bangladesh',
      prayerCalculationMethod: map['prayerCalculationMethod'] as int? ?? 1,
      enableCellularCalls: map['enableCellularCalls'] as bool? ?? true,
      enableWhatsAppCalls: map['enableWhatsAppCalls'] as bool? ?? true,
      enableMessengerCalls: map['enableMessengerCalls'] as bool? ?? true,
      enableTelegramCalls: map['enableTelegramCalls'] as bool? ?? true,
    );
  }
}
