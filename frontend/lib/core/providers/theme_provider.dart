import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme_mode') ?? 'system';

    switch (themeString) {
      case 'light':
        _themeMode = AppThemeMode.light;
        break;
      case 'dark':
        _themeMode = AppThemeMode.dark;
        break;
      default:
        _themeMode = AppThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode newThemeMode) async {
    if (newThemeMode == _themeMode) return;

    final prefs = await SharedPreferences.getInstance();
    String themeString;

    switch (newThemeMode) {
      case AppThemeMode.light:
        themeString = 'light';
        break;
      case AppThemeMode.dark:
        themeString = 'dark';
        break;
      case AppThemeMode.system:
        themeString = 'system';
        break;
    }

    await prefs.setString('theme_mode', themeString);
    _themeMode = newThemeMode;
    notifyListeners();
  }

  String getThemeDisplayName(
      AppThemeMode mode, String lightText, String darkText, String systemText) {
    switch (mode) {
      case AppThemeMode.light:
        return lightText;
      case AppThemeMode.dark:
        return darkText;
      case AppThemeMode.system:
        return systemText;
    }
  }
}
