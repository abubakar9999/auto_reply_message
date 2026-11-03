import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/preset_statuses.dart';
import '../../core/services/background_service.dart';
import '../../domain/entities/busy_status.dart';
import 'database_provider.dart';

final allStatusesStreamProvider = StreamProvider<List<BusyStatus>>((ref) {
  final repo = ref.watch(busyStatusRepositoryProvider);
  return repo.watchAllStatuses();
});

class BusyStatusNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> addStatus(BusyStatus status) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(busyStatusRepositoryProvider);
      await repo.insertStatus(status);
      BackgroundServiceManager().updateStatusNow();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStatus(BusyStatus status) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(busyStatusRepositoryProvider);
      await repo.updateStatus(status);
      BackgroundServiceManager().updateStatusNow();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteStatus(String id) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(busyStatusRepositoryProvider);
      await repo.deleteStatus(id);
      BackgroundServiceManager().updateStatusNow();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleEnabled(String id, bool isEnabled) async {
    try {
      final repo = ref.read(busyStatusRepositoryProvider);
      await repo.setStatusEnabled(id, isEnabled);
      BackgroundServiceManager().updateStatusNow();
    } catch (_) {}
  }

  Future<void> setQuickBusy(int durationMinutes, {String? customNote}) async {
    final now = DateTime.now();
    final expiresAt = now.add(Duration(minutes: durationMinutes));
    final startMins = now.hour * 60 + now.minute;
    final endMins = expiresAt.hour * 60 + expiresAt.minute;

    final repo = ref.read(busyStatusRepositoryProvider);
    await repo.clearQuickToggles();

    const uuid = Uuid();
    final quickStatus = BusyStatus(
      id: 'quick_busy_${uuid.v4().substring(0, 8)}',
      title: customNote?.trim().isNotEmpty == true
          ? customNote!
          : 'Quick Busy',
      iconKey: 'clock',
      colorValue: 0xFFF59E0B, // Amber
      startMinutes: startMins,
      endMinutes: endMins,
      repeatDays: const [1, 2, 3, 4, 5, 6, 7],
      isOneTime: true,
      oneTimeDate: now,
      messageTemplate: 'Ami busy a aci, {duration} min por call divo.',
      isEnabled: true,
      priority: 999, // Highest priority
      isQuickToggle: true,
      quickToggleExpiresAt: expiresAt,
    );

    await repo.insertStatus(quickStatus);
    BackgroundServiceManager().updateStatusNow();
  }

  Future<void> cancelQuickBusy() async {
    final repo = ref.read(busyStatusRepositoryProvider);
    await repo.clearQuickToggles();
    BackgroundServiceManager().updateStatusNow();
  }

  Future<void> populateDefaultPresets({bool isBangla = true}) async {
    final repo = ref.read(busyStatusRepositoryProvider);
    const uuid = Uuid();
    final list = PresetStatuses.presets.map((p) {
      return p.toBusyStatus(
        id: 'preset_${uuid.v4().substring(0, 8)}',
        isBangla: isBangla,
      );
    }).toList();

    await repo.insertPresetStatuses(list);
    BackgroundServiceManager().updateStatusNow();
  }
}

final busyStatusNotifierProvider =
    NotifierProvider<BusyStatusNotifier, AsyncValue<void>>(
        BusyStatusNotifier.new);
