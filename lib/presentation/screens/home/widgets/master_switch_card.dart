import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/services/background_service.dart';
import '../../../providers/settings_provider.dart';

class MasterSwitchCard extends ConsumerWidget {
  const MasterSwitchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final isEnabled = settings.isMasterEnabled;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? [
                  AppColors.primary,
                  const Color(0xFF0F766E),
                ]
              : [
                  const Color(0xFF475569),
                  const Color(0xFF334155),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isEnabled ? AppColors.primary : Colors.black)
                .withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(35),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEnabled
                  ? Icons.shield_rounded
                  : Icons.shield_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnabled
                      ? context.tr('master_switch_on')
                      : context.tr('master_switch_off'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr('master_switch_desc'),
                  style: TextStyle(
                    color: Colors.white.withAlpha(210),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.95,
            child: Switch(
              value: isEnabled,
              onChanged: (val) {
                ref.read(settingsNotifierProvider.notifier).setMasterEnabled(val);
                if (val) {
                  BackgroundServiceManager().start();
                } else {
                  BackgroundServiceManager().stop();
                }
              },
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.statusActive,
              inactiveThumbColor: Colors.white70,
              inactiveTrackColor: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}

