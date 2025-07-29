import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coliseum/services/localization_service.dart';

class SettingsService extends ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _languageKey = 'language';
  static const String _biometricEnabledKey = 'biometric_enabled';

  bool _isDarkMode = false;
  String _language = 'es';
  bool _biometricEnabled = false;

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get biometricEnabled => _biometricEnabled;

  SettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _language = prefs.getString(_languageKey) ?? 'es';
    _biometricEnabled = prefs.getBool(_biometricEnabledKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode, LocalizationService? localizationService) async {
    _language = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _language);
    
    // Update localization service if provided
    if (localizationService != null) {
      await localizationService.setLanguage(languageCode);
    }
    
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    _biometricEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, _biometricEnabled);
    notifyListeners();
  }

  ThemeData getTheme() {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );

  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
} 