import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_localizations.dart';
import 'core/services/background_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/permission_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/widgets/app_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Safely initialize notifications and background service
  try {
    await NotificationService().init();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
  }

  try {
    await BackgroundServiceManager().initialize();
  } catch (e) {
    debugPrint('Failed to initialize background service: $e');
  }

  runApp(
    const ProviderScope(
      child: BusyAutoReplyApp(),
    ),
  );
}

class BusyAutoReplyApp extends ConsumerWidget {
  const BusyAutoReplyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final perms = ref.watch(permissionProvider);

    ThemeMode themeMode;
    switch (settings.themeMode.toLowerCase()) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'system':
      default:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp(
      title: 'Busy Auto-Reply',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: Locale(settings.language),
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: perms.isCoreGranted
          ? const AppMainScaffold()
          : const OnboardingScreen(),
    );
  }
}
