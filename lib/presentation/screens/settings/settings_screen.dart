import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/background_service.dart';
import '../../../core/services/native_sms_service.dart';
import '../../providers/permission_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);
    final perms = ref.watch(permissionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('settings_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Section: General Settings
          _SectionHeader(title: context.tr('settings_title')),
          const SizedBox(height: 8),

          // Language Selector
          _SettingsCard(
            child: ListTile(
              leading:
                  const Icon(Icons.language_rounded, color: AppColors.primary),
              title: Text(context.tr('language_label')),
              subtitle: Text(
                  settings.language == 'bn' ? 'বাংলা (Bangla)' : 'English'),
              trailing: DropdownButton<String>(
                value: settings.language,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (val) {
                  if (val != null) notifier.setLanguage(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Theme Selector
          _SettingsCard(
            child: ListTile(
              leading:
                  const Icon(Icons.palette_outlined, color: AppColors.primary),
              title: Text(context.tr('theme_label')),
              subtitle: Text(settings.themeMode.toUpperCase()),
              trailing: DropdownButton<String>(
                value: settings.themeMode,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(
                      value: 'system', child: Text(context.tr('theme_system'))),
                  DropdownMenuItem(
                      value: 'light', child: Text(context.tr('theme_light'))),
                  DropdownMenuItem(
                      value: 'dark', child: Text(context.tr('theme_dark'))),
                ],
                onChanged: (val) {
                  if (val != null) notifier.setThemeMode(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section: Call Sources (Phone, WhatsApp, Messenger, Telegram)
          _SectionHeader(title: context.tr('call_sources_title')),
          const SizedBox(height: 4),
          Text(
            context.tr('call_sources_desc'),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),

          // Cellular Calls Toggle
          _SettingsCard(
            child: SwitchListTile(
              secondary: const Icon(Icons.phone_rounded, color: AppColors.primary),
              title: Text(
                context.tr('source_cellular'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                context.tr('source_cellular_desc'),
                style: const TextStyle(fontSize: 12),
              ),
              value: settings.enableCellularCalls,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => notifier.toggleEnableCellular(val),
            ),
          ),
          const SizedBox(height: 8),

          // WhatsApp Calls Toggle
          _SettingsCard(
            child: SwitchListTile(
              secondary: const Icon(Icons.chat_bubble_rounded,
                  color: Color(0xFF25D366)),
              title: Text(
                context.tr('source_whatsapp'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                context.tr('source_whatsapp_desc'),
                style: const TextStyle(fontSize: 12),
              ),
              value: settings.enableWhatsAppCalls,
              activeThumbColor: const Color(0xFF25D366),
              onChanged: (val) => notifier.toggleEnableWhatsApp(val),
            ),
          ),
          const SizedBox(height: 8),

          // Facebook Messenger Toggle
          _SettingsCard(
            child: SwitchListTile(
              secondary: const Icon(Icons.maps_ugc_rounded,
                  color: Color(0xFF0084FF)),
              title: Text(
                context.tr('source_messenger'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                context.tr('source_messenger_desc'),
                style: const TextStyle(fontSize: 12),
              ),
              value: settings.enableMessengerCalls,
              activeThumbColor: const Color(0xFF0084FF),
              onChanged: (val) => notifier.toggleEnableMessenger(val),
            ),
          ),
          const SizedBox(height: 8),

          // Telegram Calls Toggle
          _SettingsCard(
            child: SwitchListTile(
              secondary: const Icon(Icons.send_rounded, color: Color(0xFF0088CC)),
              title: Text(
                context.tr('source_telegram'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                context.tr('source_telegram_desc'),
                style: const TextStyle(fontSize: 12),
              ),
              value: settings.enableTelegramCalls,
              activeThumbColor: const Color(0xFF0088CC),
              onChanged: (val) => notifier.toggleEnableTelegram(val),
            ),
          ),
          const SizedBox(height: 20),

          // Notification Access Card (For VoIP calls)
          _SectionHeader(title: context.tr('notification_access_title')),
          const SizedBox(height: 8),
          _SettingsCard(
            child: ListTile(
              leading: Icon(
                perms.notificationListenerGranted
                    ? Icons.notifications_active_rounded
                    : Icons.notification_important_rounded,
                color: perms.notificationListenerGranted
                    ? AppColors.statusActive
                    : Colors.amber.shade800,
              ),
              title: Text(
                context.tr('notification_access_title'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                perms.notificationListenerGranted
                    ? context.tr('notification_access_granted')
                    : context.tr('notification_access_desc'),
                style: TextStyle(
                  fontSize: 12,
                  color: perms.notificationListenerGranted
                      ? AppColors.statusActive
                      : Colors.grey.shade700,
                ),
              ),
              trailing: perms.notificationListenerGranted
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.statusActive)
                  : TextButton(
                      onPressed: () async {
                        await ref
                            .read(permissionProvider.notifier)
                            .requestNotificationListenerPermission();
                      },
                      child: Text(context.tr('grant_permission')),
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // Section: Rules & Timing
          _SectionHeader(title: context.tr('cooldown_label')),
          const SizedBox(height: 8),

          // Cooldown Slider Card
          _SettingsCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('cooldown_label'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${settings.cooldownMinutes} ${context.tr('minutes_unit')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr('cooldown_desc'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Slider(
                    value: settings.cooldownMinutes.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      notifier.setCooldown(val.round());
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Log Retention
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.history_toggle_off_rounded,
                  color: AppColors.primary),
              title: Text(context.tr('log_retention')),
              subtitle: Text(context.tr('log_retention_desc')),
              trailing: DropdownButton<int>(
                value: settings.logRetentionDays,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(
                      value: 7, child: Text(context.tr('retention_7'))),
                  DropdownMenuItem(
                      value: 15, child: Text(context.tr('retention_15'))),
                  DropdownMenuItem(
                      value: 30, child: Text(context.tr('retention_30'))),
                  DropdownMenuItem(
                      value: 0, child: Text(context.tr('retention_forever'))),
                ],
                onChanged: (val) {
                  if (val != null) notifier.setRetentionDays(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section: System & Background Service
          _SectionHeader(title: context.tr('bg_service_status')),
          const SizedBox(height: 8),

          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.miscellaneous_services_rounded,
                  color: AppColors.primary),
              title: Text(context.tr('bg_service_status')),
              subtitle: Text(
                settings.isMasterEnabled
                    ? context.tr('bg_service_active')
                    : context.tr('bg_service_inactive'),
                style: TextStyle(
                  color: settings.isMasterEnabled
                      ? AppColors.statusActive
                      : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: TextButton(
                onPressed: () async {
                  await BackgroundServiceManager().initialize();
                  await BackgroundServiceManager().start();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Monitoring background service restarted.'),
                        backgroundColor: AppColors.statusActive,
                      ),
                    );
                  }
                },
                child: Text(context.tr('restart_service')),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Battery Optimization Card
          _SettingsCard(
            child: ListTile(
              leading: const Icon(Icons.battery_saver_rounded,
                  color: AppColors.accent),
              title: Text(context.tr('battery_optimization')),
              subtitle: Text(
                perms.batteryOptimizationIgnored
                    ? context.tr('battery_opt_ignored')
                    : context.tr('battery_opt_restricted'),
                style: TextStyle(
                  fontSize: 12,
                  color: perms.batteryOptimizationIgnored
                      ? AppColors.statusActive
                      : Colors.orange.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: perms.batteryOptimizationIgnored
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.statusActive)
                  : TextButton(
                      onPressed: () async {
                        await NativeSmsService()
                            .requestIgnoreBatteryOptimizations();
                        await ref.read(permissionProvider.notifier).checkAll();
                      },
                      child: Text(context.tr('grant_permission')),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // About Card
          _SettingsCard(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('about_title'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr('version_label'),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Built with Flutter, Riverpod, Drift (SQLite), Native Android Telephony, and VoIP Notification Interception.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withAlpha(30)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
