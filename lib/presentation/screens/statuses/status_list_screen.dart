import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/preset_statuses.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/time_utils.dart';
import '../../../domain/entities/busy_status.dart';
import '../../providers/busy_status_provider.dart';
import 'add_edit_status_screen.dart';

class StatusListScreen extends ConsumerWidget {
  const StatusListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusesAsync = ref.watch(allStatusesStreamProvider);
    final isBn = context.isBangla;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('statuses_title')),
        actions: [
          IconButton(
            tooltip: context.tr('presets_button'),
            icon: const Icon(Icons.playlist_add_rounded),
            onPressed: () {
              ref
                  .read(busyStatusNotifierProvider.notifier)
                  .populateDefaultPresets(isBangla: isBn);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Default preset schedules loaded!'),
                  backgroundColor: AppColors.statusActive,
                ),
              );
            },
          ),
        ],
      ),
      body: statusesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (statuses) {
          if (statuses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.schedule_rounded,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.tr('statuses_title'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No schedules yet. Create your own schedule or load default presets like Prayer, Sleep, Meeting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(busyStatusNotifierProvider.notifier)
                            .populateDefaultPresets(isBangla: isBn);
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: Text(context.tr('presets_button')),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: statuses.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final status = statuses[index];
              return _StatusListTile(status: status);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddEditStatusScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          context.tr('add_status'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _StatusListTile extends ConsumerWidget {
  final BusyStatus status;

  const _StatusListTile({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBn = context.isBangla;
    final statusColor = Color(status.colorValue);

    final startFormatted = TimeUtils.formatMinutesTo12Hour(
      status.startMinutes,
      isBangla: isBn,
    );
    final endFormatted = TimeUtils.formatMinutesTo12Hour(
      status.endMinutes,
      isBangla: isBn,
    );

    // Days label
    String daysLabel;
    if (status.isOneTime) {
      if (status.oneTimeDate != null) {
        final d = status.oneTimeDate!;
        daysLabel = '${d.day}/${d.month}/${d.year}';
      } else {
        daysLabel = context.tr('is_one_time');
      }
    } else if (status.repeatDays.length == 7) {
      daysLabel = context.tr('all_days');
    } else {
      daysLabel = status.repeatDays
          .map((d) => TimeUtils.appWeekdayName(d, isBangla: isBn))
          .join(', ');
    }

    return Dismissible(
      key: Key(status.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.statusError,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(context.tr('delete_status')),
                content: Text(context.tr('delete_confirm')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(context.tr('cancel')),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusError),
                    child: Text(context.tr('delete')),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        ref.read(busyStatusNotifierProvider.notifier).deleteStatus(status.id);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddEditStatusScreen(existingStatus: status),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: status.isEnabled
                  ? statusColor.withAlpha(50)
                  : Colors.grey.withAlpha(30),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                status.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: status.isEnabled
                                      ? null
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ),
                            if (status.priority >= 10) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(30),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  context.tr('priority_high'),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$startFormatted - $endFormatted • $daysLabel',
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
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.messageTemplate,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
