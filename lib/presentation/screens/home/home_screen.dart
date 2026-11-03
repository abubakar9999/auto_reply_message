import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../providers/call_log_provider.dart';
import '../../providers/settings_provider.dart';
import '../statuses/add_edit_status_screen.dart';
import 'widgets/current_status_card.dart';
import 'widgets/master_switch_card.dart';
import 'widgets/prayer_sync_dialog.dart';
import 'widgets/quick_busy_sheet.dart';
import 'widgets/today_schedule_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final repliedCountAsync = ref.watch(todayRepliedCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_chat_unread_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              context.tr('app_title'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: context.tr('sync_prayer_times'),
            icon: const Icon(Icons.mosque_rounded),
            onPressed: () => PrayerSyncDialog.show(context),
          ),
          IconButton(
            tooltip: 'Language',
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                settings.language == 'bn' ? 'EN' : 'বাং',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            onPressed: () {
              final newLang = settings.language == 'bn' ? 'en' : 'bn';
              ref.read(settingsNotifierProvider.notifier).setLanguage(newLang);
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayRepliedCountProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Master On/Off Switch
              const MasterSwitchCard(),
              const SizedBox(height: 16),

              // Current Status Card (Active vs Standby)
              const CurrentStatusCard(),
              const SizedBox(height: 16),

              // Action Bar: Quick Busy & Add Schedule
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => QuickBusySheet.show(context),
                      icon: const Icon(Icons.bolt_rounded, size: 20),
                      label: Text(context.tr('quick_busy_button')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddEditStatusScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: Text(context.tr('add_status')),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats summary banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.withAlpha(30)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_mode_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.isBangla
                          ? 'আজকে স্বয়ংক্রিয় এসএমএস গেছে:'
                          : "Auto-replies dispatched today:",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        repliedCountAsync.when(
                          data: (count) => context.isBangla
                              ? count.toString().replaceAll('0', '০').replaceAll('1', '১').replaceAll('2', '২').replaceAll('3', '৩').replaceAll('4', '৪').replaceAll('5', '৫').replaceAll('6', '৬').replaceAll('7', '৭').replaceAll('8', '৮').replaceAll('9', '৯')
                              : count.toString(),
                          loading: () => '...',
                          error: (e, s) => '0',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Today's schedule section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('today_schedule'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const TodayScheduleView(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
