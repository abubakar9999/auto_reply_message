import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/preset_statuses.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../providers/active_status_timer_provider.dart';
import '../../../providers/busy_status_provider.dart';

class CurrentStatusCard extends ConsumerWidget {
  const CurrentStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStatus = ref.watch(currentActiveStatusProvider);
    final isBn = context.isBangla;

    if (activeStatus == null) {
      // Standby state
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.withAlpha(40), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.ring_volume_rounded,
                  color: Color(0xFF64748B),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('standby_mode'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr('standby_desc'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Active status card
    final currentMinutes = DateTime.now().hour * 60 + DateTime.now().minute;
    final remainingMinutes = TimeUtils.calculateRemainingMinutes(
      currentMinutes: currentMinutes,
      startMinutes: activeStatus.startMinutes,
      endMinutes: activeStatus.endMinutes,
    );

    final returnTimeStr = TimeUtils.formatMinutesTo12Hour(
      activeStatus.endMinutes,
      isBangla: isBn,
    );

    final durationStr = TimeUtils.formatDurationMinutes(
      remainingMinutes > 0 ? remainingMinutes : 5,
      isBangla: isBn,
    );

    final statusColor = Color(activeStatus.colorValue);

    return Container(
      decoration: BoxDecoration(
        color: statusColor.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withAlpha(80), width: 1.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withAlpha(70),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  PresetStatuses.getIcon(activeStatus.iconKey),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.statusActive.withAlpha(35),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        context.tr('master_switch_on'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.statusActive,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activeStatus.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (activeStatus.isQuickToggle)
                IconButton(
                  tooltip: context.tr('quick_busy_cancel'),
                  onPressed: () {
                    ref.read(busyStatusNotifierProvider.notifier).cancelQuickBusy();
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.redAccent,
                    size: 26,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.tr('time_remaining', {'duration': durationStr}),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.tr('return_time_label', {'time': returnTimeStr}),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

