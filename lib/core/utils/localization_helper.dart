import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

/// Extension to make accessing AppLocalizations easier
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Helper class for working with localizations
class LocalizationHelper {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
  
  static bool isVietnamese(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'vi';
  }
  
  static bool isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }
}