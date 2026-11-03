import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/contacts_service.dart';
import '../../core/services/native_sms_service.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/repositories/busy_status_repository_impl.dart';
import '../../data/repositories/call_log_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/whitelist_repository_impl.dart';
import '../../domain/repositories/i_busy_status_repository.dart';
import '../../domain/repositories/i_call_log_repository.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../domain/repositories/i_whitelist_repository.dart';
import '../../domain/usecases/fetch_prayer_times_usecase.dart';
import '../../domain/usecases/format_reply_message_usecase.dart';
import '../../domain/usecases/match_busy_status_usecase.dart';
import '../../domain/usecases/should_send_reply_usecase.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final busyStatusRepositoryProvider = Provider<IBusyStatusRepository>((ref) {
  return BusyStatusRepositoryImpl(ref.watch(appDatabaseProvider));
});

final callLogRepositoryProvider = Provider<ICallLogRepository>((ref) {
  return CallLogRepositoryImpl(ref.watch(appDatabaseProvider));
});

final whitelistRepositoryProvider = Provider<IWhitelistRepository>((ref) {
  return WhitelistRepositoryImpl(ref.watch(appDatabaseProvider));
});

final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

final matchBusyStatusUseCaseProvider = Provider<MatchBusyStatusUseCase>((ref) {
  return MatchBusyStatusUseCase();
});

final formatReplyMessageUseCaseProvider = Provider<FormatReplyMessageUseCase>((ref) {
  return FormatReplyMessageUseCase();
});

final shouldSendReplyUseCaseProvider = Provider<ShouldSendReplyUseCase>((ref) {
  return ShouldSendReplyUseCase();
});

final fetchPrayerTimesUseCaseProvider = Provider<FetchPrayerTimesUseCase>((ref) {
  return FetchPrayerTimesUseCase();
});

final contactsServiceProvider = Provider<ContactsService>((ref) {
  return ContactsService();
});

final nativeSmsServiceProvider = Provider<NativeSmsService>((ref) {
  return NativeSmsService();
});

