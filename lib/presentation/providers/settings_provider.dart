import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/background_service.dart';
import '../../domain/entities/app_settings.dart';
import 'database_provider.dart';

final settingsStreamProvider = StreamProvider<AppSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchSettings();
});

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    ref.watch(settingsStreamProvider).whenData((data) {
      state = data;
    });
    return const AppSettings();
  }

  Future<void> setMasterEnabled(bool enabled) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setMasterEnabled(enabled);
    state = state.copyWith(isMasterEnabled: enabled);
    BackgroundServiceManager().updateStatusNow();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveSettings(newSettings);
    state = newSettings;
    BackgroundServiceManager().updateStatusNow();
  }

  Future<void> setLanguage(String lang) async {
    await updateSettings(state.copyWith(language: lang));
  }

  Future<void> setThemeMode(String theme) async {
    await updateSettings(state.copyWith(themeMode: theme));
  }

  Future<void> setCooldown(int minutes) async {
    await updateSettings(state.copyWith(cooldownMinutes: minutes));
  }

  Future<void> setRetentionDays(int days) async {
    await updateSettings(state.copyWith(logRetentionDays: days));
  }

  Future<void> toggleOnlyContacts(bool onlyContacts) async {
    await updateSettings(state.copyWith(onlyReplyToContacts: onlyContacts));
  }

  Future<void> toggleSkipUnknown(bool skipUnknown) async {
    await updateSettings(state.copyWith(skipUnknownNumbers: skipUnknown));
  }

  Future<void> toggleEnableCellular(bool enabled) async {
    await updateSettings(state.copyWith(enableCellularCalls: enabled));
  }

  Future<void> toggleEnableWhatsApp(bool enabled) async {
    await updateSettings(state.copyWith(enableWhatsAppCalls: enabled));
  }

  Future<void> toggleEnableMessenger(bool enabled) async {
    await updateSettings(state.copyWith(enableMessengerCalls: enabled));
  }

  Future<void> toggleEnableTelegram(bool enabled) async {
    await updateSettings(state.copyWith(enableTelegramCalls: enabled));
  }
}

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
