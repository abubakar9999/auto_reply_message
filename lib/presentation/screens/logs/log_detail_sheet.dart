import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/call_log_entry.dart';
import '../../providers/call_log_provider.dart';
import '../../providers/whitelist_provider.dart';

class LogDetailSheet extends ConsumerWidget {
  final CallLogEntry log;

  const LogDetailSheet({super.key, required this.log});

  static Future<void> show(BuildContext context, CallLogEntry log) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogDetailSheet(log: log),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color badgeColor;
    IconData badgeIcon;
    switch (log.smsResult) {
      case SmsResult.sent:
        badgeColor = AppColors.statusActive;
        badgeIcon = Icons.check_circle_rounded;
        break;
      case SmsResult.skipped:
        badgeColor = AppColors.statusInactive;
        badgeIcon = Icons.do_not_disturb_on_rounded;
        break;
      case SmsResult.failed:
        badgeColor = AppColors.statusError;
        badgeIcon = Icons.error_rounded;
        break;
    }

    final formattedTime =
        DateFormat('dd MMM yyyy, hh:mm a').format(log.callTime);

    IconData sourceIcon;
    String sourceName;
    switch (log.callSource.toLowerCase()) {
      case 'whatsapp':
        sourceIcon = Icons.chat_bubble_rounded;
        sourceName = 'WhatsApp';
        break;
      case 'messenger':
        sourceIcon = Icons.maps_ugc_rounded;
        sourceName = 'Messenger';
        break;
      case 'telegram':
        sourceIcon = Icons.send_rounded;
        sourceName = 'Telegram';
        break;
      case 'cellular':
      default:
        sourceIcon = Icons.phone_rounded;
        sourceName = 'Phone Call (SIM)';
        break;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(badgeIcon, color: badgeColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.contactName ?? log.callerNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (log.contactName != null)
                      Text(
                        log.callerNumber,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  log.smsResult.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),

          _DetailRow(
            icon: sourceIcon,
            label: context.tr('source_label'),
            value: sourceName,
          ),
          const SizedBox(height: 12),

          _DetailRow(
            icon: Icons.access_time_rounded,
            label: context.tr('call_time'),
            value: formattedTime,
          ),
          const SizedBox(height: 12),

          _DetailRow(
            icon: Icons.notifications_active_outlined,
            label: context.tr('status_applied'),
            value: log.activeStatusTitle,
          ),
          const SizedBox(height: 12),

          if (log.messageSent.isNotEmpty) ...[
            _DetailRow(
              icon: Icons.chat_bubble_outline_rounded,
              label: context.tr('message_sent_label'),
              value: log.messageSent,
            ),
            const SizedBox(height: 12),
          ],

          if (log.skipOrFailureReason != null) ...[
            _DetailRow(
              icon: Icons.info_outline_rounded,
              label: context.tr('reason_label'),
              value: log.skipOrFailureReason!,
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(whitelistActionsProvider.notifier).addContact(
                          phoneNumber: log.callerNumber,
                          displayName: log.contactName ?? log.callerNumber,
                        );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Added ${log.callerNumber} to whitelist.'),
                        backgroundColor: AppColors.statusActive,
                      ),
                    );
                  },
                  icon: const Icon(Icons.shield_outlined, size: 18),
                  label: Text(context.tr('add_to_whitelist')),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                tooltip: context.tr('delete'),
                onPressed: () {
                  ref
                      .read(callLogActionsProvider.notifier)
                      .deleteLog(log.id);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

