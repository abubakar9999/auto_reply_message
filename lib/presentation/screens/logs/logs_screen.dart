import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/call_log_entry.dart';
import '../../providers/call_log_provider.dart';
import 'log_detail_sheet.dart';

class LogsScreen extends ConsumerStatefulWidget {
  const LogsScreen({super.key});

  @override
  ConsumerState<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends ConsumerState<LogsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDateHeader(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final logDate = DateTime(date.year, date.month, date.day);

    if (logDate == today) {
      return context.isBangla ? 'আজ' : 'Today';
    } else if (logDate == yesterday) {
      return context.isBangla ? 'গতকাল' : 'Yesterday';
    } else {
      return DateFormat('EEE, dd MMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = ref.watch(filteredCallLogsProvider);
    final filterState = ref.watch(callLogFilterProvider);
    final filterNotifier = ref.read(callLogFilterProvider.notifier);

    // Group logs by date
    final Map<String, List<CallLogEntry>> grouped = {};
    for (final log in filteredLogs) {
      final key = DateFormat('yyyy-MM-dd').format(log.callTime);
      grouped.putIfAbsent(key, () => []).add(log);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('logs_title')),
        actions: [
          IconButton(
            tooltip: context.tr('export_csv'),
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () async {
              try {
                final path = await ref
                    .read(callLogActionsProvider.notifier)
                    .exportToCsv();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('export_success', {'path': path})),
                      backgroundColor: AppColors.statusActive,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Export failed: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            tooltip: context.tr('clear_logs'),
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(context.tr('clear_logs')),
                  content: Text(context.tr('clear_logs_confirm')),
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
              );

              if (confirm == true) {
                ref.read(callLogActionsProvider.notifier).clearAllLogs();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: context.tr('search_logs'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              filterNotifier.setSearchQuery('');
                            },
                          )
                        : null,
                    isDense: true,
                  ),
                  onChanged: (val) => filterNotifier.setSearchQuery(val),
                ),
                const SizedBox(height: 12),
                // Filter Tabs (All, Sent, Skipped, Failed)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterTab(
                        label: context.tr('filter_all'),
                        isSelected: filterState.resultFilter == null,
                        onTap: () => filterNotifier.setResultFilter(null),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: context.tr('filter_sent'),
                        isSelected:
                            filterState.resultFilter == SmsResult.sent,
                        activeColor: AppColors.statusActive,
                        onTap: () =>
                            filterNotifier.setResultFilter(SmsResult.sent),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: context.tr('filter_skipped'),
                        isSelected:
                            filterState.resultFilter == SmsResult.skipped,
                        activeColor: AppColors.statusInactive,
                        onTap: () =>
                            filterNotifier.setResultFilter(SmsResult.skipped),
                      ),
                      const SizedBox(width: 8),
                      _FilterTab(
                        label: context.tr('filter_failed'),
                        isSelected:
                            filterState.resultFilter == SmsResult.failed,
                        activeColor: AppColors.statusError,
                        onTap: () =>
                            filterNotifier.setResultFilter(SmsResult.failed),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Log List
          Expanded(
            child: grouped.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.tr('no_logs_found'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: grouped.keys.length,
                    itemBuilder: (context, groupIndex) {
                      final dateKey = grouped.keys.elementAt(groupIndex);
                      final logsInDate = grouped[dateKey]!;
                      final headerText = _formatDateHeader(
                          logsInDate.first.callTime, context);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              headerText,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          ...logsInDate.map((log) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _LogTile(log: log),
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? activeColor;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = activeColor ?? AppColors.primary;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: effectiveColor,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : null,
      ),
      onSelected: (_) => onTap(),
    );
  }
}

class _LogTile extends StatelessWidget {
  final CallLogEntry log;

  const _LogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData icon;
    switch (log.smsResult) {
      case SmsResult.sent:
        badgeColor = AppColors.statusActive;
        icon = Icons.call_missed_outgoing_rounded;
        break;
      case SmsResult.skipped:
        badgeColor = AppColors.statusInactive;
        icon = Icons.call_missed_rounded;
        break;
      case SmsResult.failed:
        badgeColor = AppColors.statusError;
        icon = Icons.sms_failed_rounded;
        break;
    }

    final timeStr = DateFormat('hh:mm a').format(log.callTime);

    Color sourceColor;
    IconData sourceIcon;
    String sourceName;
    switch (log.callSource.toLowerCase()) {
      case 'whatsapp':
        sourceColor = const Color(0xFF25D366);
        sourceIcon = Icons.chat_bubble_rounded;
        sourceName = 'WhatsApp';
        break;
      case 'messenger':
        sourceColor = const Color(0xFF0084FF);
        sourceIcon = Icons.maps_ugc_rounded;
        sourceName = 'Messenger';
        break;
      case 'telegram':
        sourceColor = const Color(0xFF0088CC);
        sourceIcon = Icons.send_rounded;
        sourceName = 'Telegram';
        break;
      case 'cellular':
      default:
        sourceColor = AppColors.primary;
        sourceIcon = Icons.phone_rounded;
        sourceName = 'Phone';
        break;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => LogDetailSheet.show(context, log),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withAlpha(30)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: badgeColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: badgeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        log.contactName ?? log.callerNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: sourceColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(sourceIcon, size: 11, color: sourceColor),
                            const SizedBox(width: 3),
                            Text(
                              sourceName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: sourceColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.activeStatusTitle,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        log.smsResult.displayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ],
                  ),
                  if (log.messageSent.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      log.messageSent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ] else if (log.skipOrFailureReason != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      log.skipOrFailureReason!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

