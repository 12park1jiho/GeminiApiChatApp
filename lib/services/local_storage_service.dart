// lib/services/local_storage_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_project/models/chat_message.dart'; // ChatMessage 모델 import

class LocalStorageService {
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
}