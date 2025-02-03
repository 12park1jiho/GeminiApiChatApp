import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode');
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
            (e) => e.toString() == 'ThemeMode.$themeModeString',
        orElse: () => ThemeMode.system,
      );
    }
    notifyListeners();
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.name);
  }

  void changeTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    saveThemeMode(themeMode);
    notifyListeners();
  }
}