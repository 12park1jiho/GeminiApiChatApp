import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_project/chat/chat_message.dart';

class ApiManager {
  late Box<ChatMessage> _chatMessageBox;

  Future<void> initializeChatBox() async {
    _chatMessageBox = await Hive.openBox<ChatMessage>('chatMessages');
  }

  List<ChatMessage> getChatMessages() {
    return _chatMessageBox.values.toList();
  }

  Future<void> addChatMessage(ChatMessage message) async {
    await _chatMessageBox.add(message);
  }

  Future<void> deleteChatMessage(int index) async {
    await _chatMessageBox.deleteAt(index);
  }

  Future<void> deleteAllChatMessages() async {
    await _chatMessageBox.clear();
  }

  Future<String> sendMessageToGemini(String text) async {
    final gemini = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyC0Z90jX6QNdGrVlcirs1td4lXBtMS1c0Q', // 여기에 실제 API 키를 입력하세요!
    );
    final content = [Content.text(text)];
    final response = await gemini.generateContent(content);
    return response.text ?? '';
  }
}