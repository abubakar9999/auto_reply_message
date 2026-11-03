import 'package:flutter/widgets.dart';
import 'translations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  String translate(String key, [Map<String, String>? params]) {
    return Translations.get(key, locale.languageCode, params);
  }

  bool get isBangla => locale.languageCode == 'bn';
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'bn'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension LocalizationExtension on BuildContext {
  String tr(String key, [Map<String, String>? params]) {
    return AppLocalizations.of(this).translate(key, params);
  }

  bool get isBangla => AppLocalizations.of(this).isBangla;
}

