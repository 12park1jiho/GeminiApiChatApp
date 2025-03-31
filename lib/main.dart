import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/chat_message.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart'; // HomeScreen import 추가
import 'utils/theme_manager.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());

  final localStorageService = LocalStorageService();
  await localStorageService.initializeChatBox();

  runApp(MyApp(localStorageService: localStorageService));
}

class MyApp extends StatefulWidget {
  final LocalStorageService localStorageService;

  MyApp({required this.localStorageService});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeManager _themeManager = ThemeManager();
  late LocalStorageService _localStorageService;

  @override
  void initState() {
    super.initState();
    _localStorageService = widget.localStorageService;
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
      home: HomeScreen(), // 시작 화면을 HomeScreen으로 변경
      routes: {
        '/chat': (context) => ChatScreen(
          title: 'AI Chat',
          themeManager: _themeManager,
          localStorageService: _localStorageService,
        ), // 채팅 화면 라우트 추가
      },
    );
  }
}