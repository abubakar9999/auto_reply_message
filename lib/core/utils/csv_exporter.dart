import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/call_log_entry.dart';

class CsvExporter {
  static Future<String> exportLogsToCsv(List<CallLogEntry> logs) async {
    final List<List<dynamic>> rows = [];

    // Header row
    rows.add([
      'Log ID',
      'Caller Number',
      'Contact Name',
      'Call Date & Time',
      'Active Status',
      'SMS Result',
      'Message Sent',
      'Skip / Failure Reason',
    ]);

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    for (final log in logs) {
      rows.add([
        log.id,
        log.callerNumber,
        log.contactName ?? '',
        dateFormat.format(log.callTime),
        log.activeStatusTitle,
        log.smsResult.displayName,
        log.messageSent,
        log.skipOrFailureReason ?? '',
      ]);
    }

    final csvData = csv.encode(rows);

    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${dir.path}/busy_auto_reply_logs_$timestamp.csv');

    await file.writeAsString(csvData);
    return file.path;
  }
}
