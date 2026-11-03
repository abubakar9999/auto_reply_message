import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/services/background_service.dart';
import '../screens/home/home_screen.dart';
import '../screens/logs/logs_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/statuses/status_list_screen.dart';
import '../screens/whitelist/whitelist_screen.dart';

class AppMainScaffold extends StatefulWidget {
  const AppMainScaffold({super.key});

  @override
  State<AppMainScaffold> createState() => _AppMainScaffoldState();
}

class _AppMainScaffoldState extends State<AppMainScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _ensureServiceRunning();
  }

  void _ensureServiceRunning() async {
    try {
      final isRunning = await BackgroundServiceManager().isRunning();
      if (!isRunning) {
        await BackgroundServiceManager().start();
      }
    } catch (_) {}
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    StatusListScreen(),
    LogsScreen(),
    WhitelistScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).cardTheme.color,
        indicatorColor: AppColors.primary.withAlpha(35),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded, color: AppColors.primary),
            label: context.tr('nav_home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.schedule_outlined),
            selectedIcon: const Icon(Icons.schedule_rounded, color: AppColors.primary),
            label: context.tr('nav_statuses'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history_rounded, color: AppColors.primary),
            label: context.tr('nav_logs'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.shield_outlined),
            selectedIcon: const Icon(Icons.shield_rounded, color: AppColors.primary),
            label: context.tr('nav_whitelist'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded, color: AppColors.primary),
            label: context.tr('nav_settings'),
          ),
        ],
      ),
    );
  }
}

