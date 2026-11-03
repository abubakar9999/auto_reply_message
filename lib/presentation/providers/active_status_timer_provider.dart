import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/busy_status.dart';
import 'busy_status_provider.dart';
import 'database_provider.dart';

/// Periodically ticks every 10 seconds to refresh active busy status and countdown
final timerTickProvider = StreamProvider.autoDispose<int>((ref) {
  return Stream.periodic(const Duration(seconds: 10), (i) => i);
});

/// Evaluates and provides the currently active busy status
final currentActiveStatusProvider = Provider<BusyStatus?>((ref) {
  // Listen to periodic ticks
  ref.watch(timerTickProvider);

  final statusesAsync = ref.watch(allStatusesStreamProvider);
  final allStatuses = statusesAsync.value ?? [];
  if (allStatuses.isEmpty) return null;

  final matchUseCase = ref.watch(matchBusyStatusUseCaseProvider);
  return matchUseCase.execute(
    allStatuses: allStatuses,
    currentTime: DateTime.now(),
  );
});

