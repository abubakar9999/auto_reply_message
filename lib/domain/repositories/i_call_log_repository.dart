import '../entities/call_log_entry.dart';

abstract class ICallLogRepository {
  Stream<List<CallLogEntry>> watchAllLogs();
  Future<List<CallLogEntry>> getAllLogs();
  Future<void> insertLog(CallLogEntry log);
  Future<void> deleteLog(String id);
  Future<void> clearAllLogs();
  Future<void> cleanOldLogs(int retentionDays);
  Future<CallLogEntry?> getLastLogForCaller(String callerNumber);
  Future<int> getTodayRepliedCount();
}

