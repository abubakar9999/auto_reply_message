import '../entities/busy_status.dart';

abstract class IBusyStatusRepository {
  Stream<List<BusyStatus>> watchAllStatuses();
  Future<List<BusyStatus>> getAllStatuses();
  Future<BusyStatus?> getStatusById(String id);
  Future<void> insertStatus(BusyStatus status);
  Future<void> updateStatus(BusyStatus status);
  Future<void> deleteStatus(String id);
  Future<void> setStatusEnabled(String id, bool isEnabled);
  Future<void> clearQuickToggles();
  Future<void> insertPresetStatuses(List<BusyStatus> presets);
}

