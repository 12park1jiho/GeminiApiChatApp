// ChatScreen을 사용하는 파일 (예: main.dart)
import 'package:flutter/material.dart';
import 'package:my_flutter_project/screens/chat_screen.dart';
import 'package:my_flutter_project/services/local_storage_service.dart';
import 'package:my_flutter_project/utils/theme_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeManager _themeManager = ThemeManager();
  final LocalStorageService _localStorageService = LocalStorageService(); // LocalStorageService 인스턴스 생성

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: _themeManager.lightTheme,
      darkTheme: _themeManager.darkTheme,
      themeMode: _themeManager.themeMode,
      home: ChatScreen(
        title: 'AI Chat',
        themeManager: _themeManager,
        localStorageService: _localStorageService, // ChatScreen에 전달
      ),
    );
  }
}