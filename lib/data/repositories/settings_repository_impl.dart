import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  static const _keyMaster = 'setting_is_master_enabled';
  static const _keyDefaultMessage = 'setting_default_message';
  static const _keyCooldown = 'setting_cooldown_minutes';
  static const _keyOnlyContacts = 'setting_only_contacts';
  static const _keySkipUnknown = 'setting_skip_unknown';
  static const _keyAutoReject = 'setting_auto_reject';
  static const _keyRetentionDays = 'setting_retention_days';
  static const _keyLanguage = 'setting_language';
  static const _keyThemeMode = 'setting_theme_mode';
  static const _keyPrayerCity = 'setting_prayer_city';
  static const _keyPrayerCountry = 'setting_prayer_country';
  static const _keyPrayerMethod = 'setting_prayer_method';

  // Call source keys
  static const _keyCellular = 'setting_enable_cellular';
  static const _keyWhatsApp = 'setting_enable_whatsapp';
  static const _keyMessenger = 'setting_enable_messenger';
  static const _keyTelegram = 'setting_enable_telegram';

  final StreamController<AppSettings> _settingsStreamController =
      StreamController<AppSettings>.broadcast();

  AppSettings _cachedSettings = const AppSettings();
  bool _isLoaded = false;

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    _cachedSettings = AppSettings(
      isMasterEnabled: prefs.getBool(_keyMaster) ?? true,
      defaultMessage: prefs.getString(_keyDefaultMessage) ??
          'Ami {status} a aci, {duration} min por call divo.',
      cooldownMinutes: prefs.getInt(_keyCooldown) ?? 30,
      onlyReplyToContacts: prefs.getBool(_keyOnlyContacts) ?? false,
      skipUnknownNumbers: prefs.getBool(_keySkipUnknown) ?? true,
      autoRejectCall: prefs.getBool(_keyAutoReject) ?? false,
      logRetentionDays: prefs.getInt(_keyRetentionDays) ?? 30,
      language: prefs.getString(_keyLanguage) ?? 'bn',
      themeMode: prefs.getString(_keyThemeMode) ?? 'system',
      prayerCity: prefs.getString(_keyPrayerCity) ?? 'Dhaka',
      prayerCountry: prefs.getString(_keyPrayerCountry) ?? 'Bangladesh',
      prayerCalculationMethod: prefs.getInt(_keyPrayerMethod) ?? 1,
      enableCellularCalls: prefs.getBool(_keyCellular) ?? true,
      enableWhatsAppCalls: prefs.getBool(_keyWhatsApp) ?? true,
      enableMessengerCalls: prefs.getBool(_keyMessenger) ?? true,
      enableTelegramCalls: prefs.getBool(_keyTelegram) ?? true,
    );
    _isLoaded = true;
  }

  @override
  Future<AppSettings> getSettings() async {
    await _ensureLoaded();
    return _cachedSettings;
  }

  @override
  Stream<AppSettings> watchSettings() async* {
    await _ensureLoaded();
    yield _cachedSettings;
    yield* _settingsStreamController.stream;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMaster, settings.isMasterEnabled);
    await prefs.setString(_keyDefaultMessage, settings.defaultMessage);
    await prefs.setInt(_keyCooldown, settings.cooldownMinutes);
    await prefs.setBool(_keyOnlyContacts, settings.onlyReplyToContacts);
    await prefs.setBool(_keySkipUnknown, settings.skipUnknownNumbers);
    await prefs.setBool(_keyAutoReject, settings.autoRejectCall);
    await prefs.setInt(_keyRetentionDays, settings.logRetentionDays);
    await prefs.setString(_keyLanguage, settings.language);
    await prefs.setString(_keyThemeMode, settings.themeMode);
    await prefs.setString(_keyPrayerCity, settings.prayerCity);
    await prefs.setString(_keyPrayerCountry, settings.prayerCountry);
    await prefs.setInt(_keyPrayerMethod, settings.prayerCalculationMethod);
    await prefs.setBool(_keyCellular, settings.enableCellularCalls);
    await prefs.setBool(_keyWhatsApp, settings.enableWhatsAppCalls);
    await prefs.setBool(_keyMessenger, settings.enableMessengerCalls);
    await prefs.setBool(_keyTelegram, settings.enableTelegramCalls);

    _cachedSettings = settings;
    _settingsStreamController.add(settings);
  }

  @override
  Future<void> setMasterEnabled(bool enabled) async {
    final current = await getSettings();
    await saveSettings(current.copyWith(isMasterEnabled: enabled));
  }
}
