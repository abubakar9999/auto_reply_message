import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/csv_exporter.dart';
import '../../domain/entities/call_log_entry.dart';
import 'database_provider.dart';

final allCallLogsStreamProvider = StreamProvider<List<CallLogEntry>>((ref) {
  final repo = ref.watch(callLogRepositoryProvider);
  return repo.watchAllLogs();
});

class CallLogFilterState {
  final String searchQuery;
  final SmsResult? resultFilter; // null means all

  const CallLogFilterState({
    this.searchQuery = '',
    this.resultFilter,
  });

  CallLogFilterState copyWith({
    String? searchQuery,
    SmsResult? Function()? resultFilter,
  }) {
    return CallLogFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      resultFilter:
          resultFilter != null ? resultFilter() : this.resultFilter,
    );
  }
}

class CallLogFilterNotifier extends Notifier<CallLogFilterState> {
  @override
  CallLogFilterState build() => const CallLogFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setResultFilter(SmsResult? filter) {
    state = state.copyWith(resultFilter: () => filter);
  }

  void reset() {
    state = const CallLogFilterState();
  }
}

final callLogFilterProvider =
    NotifierProvider<CallLogFilterNotifier, CallLogFilterState>(
        CallLogFilterNotifier.new);

final filteredCallLogsProvider = Provider<List<CallLogEntry>>((ref) {
  final logsAsync = ref.watch(allCallLogsStreamProvider);
  final filter = ref.watch(callLogFilterProvider);

  final logs = logsAsync.value ?? [];
  if (logs.isEmpty) return [];

  return logs.where((log) {
    // 1. Result filter
    if (filter.resultFilter != null && log.smsResult != filter.resultFilter) {
      return false;
    }

    // 2. Search query filter
    if (filter.searchQuery.trim().isNotEmpty) {
      final q = filter.searchQuery.trim().toLowerCase();
      final matchNumber = log.callerNumber.toLowerCase().contains(q);
      final matchName = log.contactName?.toLowerCase().contains(q) ?? false;
      final matchStatus = log.activeStatusTitle.toLowerCase().contains(q);
      if (!matchNumber && !matchName && !matchStatus) return false;
    }

    return true;
  }).toList();
});

final todayRepliedCountProvider = FutureProvider<int>((ref) async {
  ref.watch(allCallLogsStreamProvider);
  final repo = ref.read(callLogRepositoryProvider);
  return await repo.getTodayRepliedCount();
});

class CallLogActionsNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> deleteLog(String id) async {
    final repo = ref.read(callLogRepositoryProvider);
    await repo.deleteLog(id);
  }

  Future<void> clearAllLogs() async {
    final repo = ref.read(callLogRepositoryProvider);
    await repo.clearAllLogs();
  }

  Future<String> exportToCsv() async {
    final logs = ref.read(filteredCallLogsProvider);
    return await CsvExporter.exportLogsToCsv(logs);
  }
}

final callLogActionsProvider =
    NotifierProvider<CallLogActionsNotifier, AsyncValue<void>>(
        CallLogActionsNotifier.new);
