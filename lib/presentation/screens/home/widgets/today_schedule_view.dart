import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/preset_statuses.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../providers/busy_status_provider.dart';
import '../../statuses/add_edit_status_screen.dart';

class TodayScheduleView extends ConsumerWidget {
  const TodayScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusesAsync = ref.watch(allStatusesStreamProvider);
    final isBn = context.isBangla;

    return statusesAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (allStatuses) {
        final now = DateTime.now();
        final currentMinutes = now.hour * 60 + now.minute;
        final todayAppWeekday = TimeUtils.dartWeekdayToAppWeekday(now.weekday);

        // Filter schedules applicable to today
        final todayStatuses = allStatuses.where((status) {
          if (status.isQuickToggle) return true;
          if (status.isOneTime) {
            if (status.oneTimeDate == null) return false;
            final d = status.oneTimeDate!;
            return d.year == now.year &&
                d.month == now.month &&
                d.day == now.day;
          }
          return status.repeatDays.contains(todayAppWeekday);
        }).toList();

        // Sort chronologically
        todayStatuses.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

        if (todayStatuses.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_available_rounded,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  context.tr('no_schedules_today'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todayStatuses.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final status = todayStatuses[index];
            final statusColor = Color(status.colorValue);

            final isCurrentlyActive = status.isEnabled &&
                TimeUtils.isTimeInside(
                  currentMinutes: currentMinutes,
                  startMinutes: status.startMinutes,
                  endMinutes: status.endMinutes,
                );

            final startFormatted = TimeUtils.formatMinutesTo12Hour(
              status.startMinutes,
              isBangla: isBn,
            );
            final endFormatted = TimeUtils.formatMinutesTo12Hour(
              status.endMinutes,
              isBangla: isBn,
            );

            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddEditStatusScreen(existingStatus: status),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrentlyActive
                        ? statusColor
                        : Colors.grey.withAlpha(35),
                    width: isCurrentlyActive ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        PresetStatuses.getIcon(status.iconKey),
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                status.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: status.isEnabled ? null : Colors.grey,
                                ),
                              ),
                              if (isCurrentlyActive) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withAlpha(30),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    context.tr('master_switch_on'),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$startFormatted - $endFormatted',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: status.isEnabled,
                      onChanged: (val) {
                        ref
                            .read(busyStatusNotifierProvider.notifier)
                            .toggleEnabled(status.id, val);
                      },
                      activeThumbColor: statusColor,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
