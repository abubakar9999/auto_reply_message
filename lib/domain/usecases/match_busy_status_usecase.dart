import '../../core/utils/time_utils.dart';
import '../entities/busy_status.dart';

class MatchBusyStatusUseCase {
  /// Evaluates all statuses and returns the currently active busy status with highest priority,
  /// or null if user is not currently in a busy schedule.
  BusyStatus? execute({
    required List<BusyStatus> allStatuses,
    required DateTime currentTime,
  }) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final todayAppWeekday = TimeUtils.dartWeekdayToAppWeekday(currentTime.weekday);

    // Calculate yesterday's app weekday for overnight check after midnight
    final yesterdayTime = currentTime.subtract(const Duration(days: 1));
    final yesterdayAppWeekday = TimeUtils.dartWeekdayToAppWeekday(yesterdayTime.weekday);

    final List<BusyStatus> activeMatches = [];

    for (final status in allStatuses) {
      if (!status.isEnabled) continue;

      // 1. Check quick-toggle
      if (status.isQuickToggle) {
        if (status.quickToggleExpiresAt != null) {
          if (currentTime.isBefore(status.quickToggleExpiresAt!)) {
            activeMatches.add(status);
            continue;
          }
        }
      }

      // 2. Check one-time status
      if (status.isOneTime) {
        if (status.oneTimeDate != null) {
          final d = status.oneTimeDate!;
          final isSameDate = d.year == currentTime.year &&
              d.month == currentTime.month &&
              d.day == currentTime.day;

          if (isSameDate) {
            if (TimeUtils.isTimeInside(
              currentMinutes: currentMinutes,
              startMinutes: status.startMinutes,
              endMinutes: status.endMinutes,
            )) {
              activeMatches.add(status);
            }
          }
        }
        continue;
      }

      // 3. Check recurring status (handles normal & overnight)
      if (status.repeatDays.isEmpty) continue;

      final isOvernight = status.endMinutes < status.startMinutes;

      if (!isOvernight) {
        // Normal schedule within same day (e.g. 13:00 to 14:00)
        final isTodayActive = status.repeatDays.contains(todayAppWeekday);
        if (isTodayActive &&
            currentMinutes >= status.startMinutes &&
            currentMinutes <= status.endMinutes) {
          activeMatches.add(status);
        }
      } else {
        // Overnight schedule (e.g. 23:00 to 07:00)
        if (currentMinutes >= status.startMinutes) {
          // Pre-midnight portion: schedule started today
          if (status.repeatDays.contains(todayAppWeekday)) {
            activeMatches.add(status);
          }
        } else if (currentMinutes <= status.endMinutes) {
          // Post-midnight portion: schedule started yesterday
          if (status.repeatDays.contains(yesterdayAppWeekday)) {
            activeMatches.add(status);
          }
        }
      }
    }

    if (activeMatches.isEmpty) return null;

    // Sort by priority descending (higher priority first)
    activeMatches.sort((a, b) {
      // Quick toggles always take top priority
      if (a.isQuickToggle && !b.isQuickToggle) return -1;
      if (!a.isQuickToggle && b.isQuickToggle) return 1;

      final priorityComparison = b.priority.compareTo(a.priority);
      if (priorityComparison != 0) return priorityComparison;

      // Secondary: higher startMinutes (more recent)
      return b.startMinutes.compareTo(a.startMinutes);
    });

    return activeMatches.first;
  }
}

