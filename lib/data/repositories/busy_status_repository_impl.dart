import 'package:drift/drift.dart';
import '../../domain/entities/busy_status.dart';
import '../../domain/repositories/i_busy_status_repository.dart';
import '../datasources/local/app_database.dart';

class BusyStatusRepositoryImpl implements IBusyStatusRepository {
  final AppDatabase _db;

  BusyStatusRepositoryImpl(this._db);

  BusyStatus _toEntity(BusyStatusEntry entry) {
    List<int> parsedDays = [];
    if (entry.repeatDays.isNotEmpty) {
      parsedDays = entry.repeatDays
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
    }
    return BusyStatus(
      id: entry.id,
      title: entry.title,
      iconKey: entry.iconKey,
      colorValue: entry.colorValue,
      startMinutes: entry.startMinutes,
      endMinutes: entry.endMinutes,
      repeatDays: parsedDays,
      isOneTime: entry.isOneTime,
      oneTimeDate: entry.oneTimeDate,
      messageTemplate: entry.messageTemplate,
      isEnabled: entry.isEnabled,
      priority: entry.priority,
      isQuickToggle: entry.isQuickToggle,
      quickToggleExpiresAt: entry.quickToggleExpiresAt,
    );
  }

  BusyStatusesTableCompanion _toCompanion(BusyStatus status) {
    return BusyStatusesTableCompanion(
      id: Value(status.id),
      title: Value(status.title),
      iconKey: Value(status.iconKey),
      colorValue: Value(status.colorValue),
      startMinutes: Value(status.startMinutes),
      endMinutes: Value(status.endMinutes),
      repeatDays: Value(status.repeatDays.join(',')),
      isOneTime: Value(status.isOneTime),
      oneTimeDate: Value(status.oneTimeDate),
      messageTemplate: Value(status.messageTemplate),
      isEnabled: Value(status.isEnabled),
      priority: Value(status.priority),
      isQuickToggle: Value(status.isQuickToggle),
      quickToggleExpiresAt: Value(status.quickToggleExpiresAt),
    );
  }

  @override
  Stream<List<BusyStatus>> watchAllStatuses() {
    return (_db.select(_db.busyStatusesTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.startMinutes, mode: OrderingMode.asc),
          ]))
        .watch()
        .map((entries) => entries.map(_toEntity).toList());
  }

  @override
  Future<List<BusyStatus>> getAllStatuses() async {
    final entries = await (_db.select(_db.busyStatusesTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.startMinutes, mode: OrderingMode.asc),
          ]))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<BusyStatus?> getStatusById(String id) async {
    final query = _db.select(_db.busyStatusesTable)
      ..where((t) => t.id.equals(id));
    final entry = await query.getSingleOrNull();
    return entry != null ? _toEntity(entry) : null;
  }

  @override
  Future<void> insertStatus(BusyStatus status) async {
    await _db
        .into(_db.busyStatusesTable)
        .insertOnConflictUpdate(_toCompanion(status));
  }

  @override
  Future<void> updateStatus(BusyStatus status) async {
    await (_db.update(_db.busyStatusesTable)
          ..where((t) => t.id.equals(status.id)))
        .write(_toCompanion(status));
  }

  @override
  Future<void> deleteStatus(String id) async {
    await (_db.delete(_db.busyStatusesTable)..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<void> setStatusEnabled(String id, bool isEnabled) async {
    await (_db.update(_db.busyStatusesTable)..where((t) => t.id.equals(id)))
        .write(BusyStatusesTableCompanion(isEnabled: Value(isEnabled)));
  }

  @override
  Future<void> clearQuickToggles() async {
    await (_db.delete(_db.busyStatusesTable)
          ..where((t) => t.isQuickToggle.equals(true)))
        .go();
  }

  @override
  Future<void> insertPresetStatuses(List<BusyStatus> presets) async {
    await _db.batch((batch) {
      for (final p in presets) {
        batch.insert(
          _db.busyStatusesTable,
          _toCompanion(p),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}

