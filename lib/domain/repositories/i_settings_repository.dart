import '../entities/app_settings.dart';

abstract class ISettingsRepository {
  Future<AppSettings> getSettings();
  Stream<AppSettings> watchSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> setMasterEnabled(bool enabled);
}

