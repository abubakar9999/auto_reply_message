import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/services/background_service.dart';
import '../../providers/permission_provider.dart';
import '../../widgets/app_scaffold.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perms = ref.watch(permissionProvider);
    final notifier = ref.read(permissionProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.tr('onboarding_title'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('onboarding_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Permissions List
              _PermissionTile(
                icon: Icons.phone_android_rounded,
                title: context.tr('perm_phone_state'),
                desc: context.tr('perm_phone_state_desc'),
                isGranted: perms.phone,
                onGrant: () => notifier.requestPhonePermission(),
              ),
              const SizedBox(height: 12),

              _PermissionTile(
                icon: Icons.sms_rounded,
                title: context.tr('perm_sms'),
                desc: context.tr('perm_sms_desc'),
                isGranted: perms.sms,
                onGrant: () => notifier.requestSmsPermission(),
              ),
              const SizedBox(height: 12),

              _PermissionTile(
                icon: Icons.contacts_rounded,
                title: context.tr('perm_contacts'),
                desc: context.tr('perm_contacts_desc'),
                isGranted: perms.contacts,
                onGrant: () => notifier.requestContactsPermission(),
              ),
              const SizedBox(height: 12),

              _PermissionTile(
                icon: Icons.notifications_rounded,
                title: context.tr('perm_notifications'),
                desc: context.tr('perm_notifications_desc'),
                isGranted: perms.notifications,
                onGrant: () => notifier.requestNotificationPermission(),
              ),
              const SizedBox(height: 12),

              _PermissionTile(
                icon: Icons.mark_chat_unread_rounded,
                title: context.tr('perm_notif_listener'),
                desc: context.tr('perm_notif_listener_desc'),
                isGranted: perms.notificationListenerGranted,
                onGrant: () => notifier.requestNotificationListenerPermission(),
              ),
              const SizedBox(height: 12),

              _PermissionTile(
                icon: Icons.battery_charging_full_rounded,
                title: context.tr('perm_battery'),
                desc: context.tr('perm_battery_desc'),
                isGranted: perms.batteryOptimizationIgnored,
                onGrant: () => notifier.requestBatteryExemption(),
              ),
              const SizedBox(height: 36),

              // Primary Action Buttons
              ElevatedButton.icon(
                onPressed: () async {
                  await notifier.requestAll();
                },
                icon: const Icon(Icons.verified_user_rounded),
                label: Text(context.tr('grant_permission')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  BackgroundServiceManager().start();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const AppMainScaffold(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.tr('get_started'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isGranted;
  final VoidCallback onGrant;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.desc,
    required this.isGranted,
    required this.onGrant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isGranted
              ? AppColors.statusActive.withAlpha(80)
              : Colors.grey.withAlpha(40),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isGranted
                  ? AppColors.statusActive.withAlpha(30)
                  : AppColors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: isGranted ? AppColors.statusActive : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isGranted)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.statusActive,
                size: 24,
              ),
            )
          else
            TextButton(
              onPressed: onGrant,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: AppColors.primary,
              ),
              child: Text(
                context.tr('grant_permission'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

