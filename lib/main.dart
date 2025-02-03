import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'chat/chat_message.dart';
import 'chat/chat_page.dart';
import 'manager/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _themeManager.addListener(_handleThemeChange);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_handleThemeChange);
    super.dispose();
  }

  Future<void> _loadThemeMode() async {
    await _themeManager.loadThemeMode();
    setState(() {});
  }

  void _handleThemeChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: _themeManager.themeMode,
      home: ChatPage(title: 'AI Chat', themeManager: _themeManager),
    );
  }
}