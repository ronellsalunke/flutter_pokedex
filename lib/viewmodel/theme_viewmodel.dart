import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

class ThemeViewModel with ChangeNotifier {
  static const _themeKey = "themeMode";
  static const _dynamicColorsKey = "dynamicColors";

  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  bool _dynamicColors = true;

  bool get dynamicColors => _dynamicColors;

  ThemeMode get currentTheme {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  String get themeModeName {
    switch (_themeMode) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  ThemeViewModel() {
    _loadTheme();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<void> setDynamicColors(bool enabled) async {
    _dynamicColors = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dynamicColorsKey, enabled);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _themeMode = AppThemeMode.values[themeIndex];
    _dynamicColors = prefs.getBool(_dynamicColorsKey) ?? true;
    notifyListeners();
  }
}
