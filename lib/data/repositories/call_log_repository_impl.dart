import 'package:drift/drift.dart';
import '../../domain/entities/call_log_entry.dart';
import '../../domain/repositories/i_call_log_repository.dart';
import '../datasources/local/app_database.dart';

class CallLogRepositoryImpl implements ICallLogRepository {
  final AppDatabase _db;

  CallLogRepositoryImpl(this._db);

  CallLogEntry _toEntity(CallLogDbEntry entry) {
    return CallLogEntry(
      id: entry.id,
      callerNumber: entry.callerNumber,
      contactName: entry.contactName,
      callTime: entry.callTime,
      activeStatusTitle: entry.activeStatusTitle,
      messageSent: entry.messageSent,
      smsResult: SmsResult.fromString(entry.smsResult),
      skipOrFailureReason: entry.skipOrFailureReason,
      callSource: entry.callSource,
    );
  }

  CallLogsTableCompanion _toCompanion(CallLogEntry entry) {
    return CallLogsTableCompanion(
      id: Value(entry.id),
      callerNumber: Value(entry.callerNumber),
      contactName: Value(entry.contactName),
      callTime: Value(entry.callTime),
      activeStatusTitle: Value(entry.activeStatusTitle),
      messageSent: Value(entry.messageSent),
      smsResult: Value(entry.smsResult.name),
      skipOrFailureReason: Value(entry.skipOrFailureReason),
      callSource: Value(entry.callSource),
    );
  }

  @override
  Stream<List<CallLogEntry>> watchAllLogs() {
    return (_db.select(_db.callLogsTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.callTime, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((entries) => entries.map(_toEntity).toList());
  }

  @override
  Future<List<CallLogEntry>> getAllLogs() async {
    final entries = await (_db.select(_db.callLogsTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.callTime, mode: OrderingMode.desc)
          ]))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<void> insertLog(CallLogEntry log) async {
    await _db.into(_db.callLogsTable).insertOnConflictUpdate(_toCompanion(log));
  }

  @override
  Future<void> deleteLog(String id) async {
    await (_db.delete(_db.callLogsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearAllLogs() async {
    await _db.delete(_db.callLogsTable).go();
  }

  @override
  Future<void> cleanOldLogs(int retentionDays) async {
    if (retentionDays <= 0) return; // 0 or negative means keep forever
    final cutoff = DateTime.now().subtract(Duration(days: retentionDays));
    await (_db.delete(_db.callLogsTable)..where((t) => t.callTime.isSmallerThanValue(cutoff))).go();
  }

  @override
  Future<CallLogEntry?> getLastLogForCaller(String callerNumber) async {
    final query = _db.select(_db.callLogsTable)
      ..where((t) => t.callerNumber.equals(callerNumber))
      ..orderBy([(t) => OrderingTerm(expression: t.callTime, mode: OrderingMode.desc)])
      ..limit(1);
    final entry = await query.getSingleOrNull();
    return entry != null ? _toEntity(entry) : null;
  }

  @override
  Future<int> getTodayRepliedCount() async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final query = _db.select(_db.callLogsTable)
      ..where((t) =>
          t.callTime.isBiggerOrEqualValue(startOfToday) &
          t.smsResult.equals(SmsResult.sent.name));
    final entries = await query.get();
    return entries.length;
  }
}

