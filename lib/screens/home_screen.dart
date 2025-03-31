// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Chat App',  // 앱 이름
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _buildContent(),
      // 배경색 또는 배경 이미지 설정
      backgroundColor: Colors.white,  // 예시: 흰색 배경
      // 또는
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/background.png'),  // 예시: 배경 이미지
      //     fit: BoxFit.cover,
      //   ),
      // ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 앱 로고 (이미지 파일 필요)
          // Image.asset(
          //   'assets/images/logo.png',
          //   width: 150,
          //   height: 150,
          // ),
          // const SizedBox(height: 20),
          const Text(
            'Welcome to AI Chat App!',  // 앱 설명 또는 주요 기능 소개
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
            icon: const Icon(Icons.chat),
            label: const Text('Go to Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // 추가적인 버튼 또는 정보 표시
          // const SizedBox(height: 10),
          // TextButton(
          //   onPressed: () {
          //     // 추가 기능 실행
          //   },
          //   child: const Text('Additional Feature'),
          // ),
        ],
      ),
    );
  }
}