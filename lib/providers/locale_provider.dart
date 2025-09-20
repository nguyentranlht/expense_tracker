import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  
  Locale _locale = const Locale('vi'); // Default to Vietnamese
  
  Locale get locale => _locale;
  
  LocaleProvider() {
    _loadSavedLocale();
  }
  
  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      _saveLocale(locale);
      notifyListeners();
    }
  }
  
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }
  
  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}