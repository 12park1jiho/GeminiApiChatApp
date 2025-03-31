// lib/utils/theme_manager.dart (예시)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 테마 설정을 저장하기 위해 필요

class ThemeManager extends ChangeNotifier { // ChangeNotifier를 상속받아 테마 변경 알림 기능 추가
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void changeTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    _saveThemeMode(); // 테마 변경 시 설정 저장
    notifyListeners(); // 테마 변경 알림
  }

  // 밝은 테마 정의
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    // 기타 밝은 테마 속성
  );

  // 어두운 테마 정의
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    // 기타 어두운 테마 속성
  );

  // 테마 설정 불러오기
  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0; // 저장된 값이 없으면 기본값(0) 사용
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners(); // 테마 변경 알림
  }

  // 테마 설정 저장
  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
  }
}