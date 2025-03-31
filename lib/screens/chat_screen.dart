import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:my_flutter_project/services/local_storage_service.dart';
import '../models/chat_message.dart';
import '../utils/theme_manager.dart';
import '../services/chat_service.dart';
import '../services/api_service.dart';
import 'chat_screen_ui.dart';

enum MessageType { sent, received }

class ChatScreen extends StatefulWidget {
  final String title;
  final ThemeManager themeManager;
  final LocalStorageService localStorageService;

  const ChatScreen({
    super.key,
    required this.title,
    required this.themeManager,
    required this.localStorageService,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _apiService = ApiService();
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  late final LocalStorageService _localStorageService;
  XFile? _selectedImage;
  String? _selectedImageName;
  late final ChatService _chatService;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _localStorageService = widget.localStorageService;
    _chatService = ChatService(
      apiService: _apiService,
    );
    _loadChatMessages();
  }

  Future<void> _loadChatMessages() async {
    final messages = widget.localStorageService.getChatMessages();
    setState(() {
      _messages.addAll(messages);
    });
  }

  Future<void> _sendMessage(String text) async {
    if (_isSending) return;

    if (text.isEmpty && _selectedImage == null) {
      return;
    }

    setState(() {
      _isSending = true;
      _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
      _textController.clear();
      // _selectedImage = null;
      // _selectedImageName = null;
    });

    try {
      final response = await _chatService.sendMessage(
        text,
        image: _selectedImage,
      );
      setState(() {
        // 백엔드로부터 받은 응답 처리
        if (response is List) {
          for (var item in response) {
            if (item['type'] == 'text') {
              _messages.add(ChatMessage(text: item['content']!, isUser: false, timestamp: DateTime.now()));
            } else if (item['type'] == 'image') {
              final base64Image = item['content']!;
              _messages.add(ChatMessage(text: "", image: base64Image, isUser: false, timestamp: DateTime.now()));
            }
          }
        } else {
          _messages.add(ChatMessage(text: 'Error: Unexpected response - $response', isUser: false, timestamp: DateTime.now()));
        }
        _selectedImage = null;
        _selectedImageName = null;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error: ${e.toString()}', isUser: false, timestamp: DateTime.now()));
        _selectedImage = null;
        _selectedImageName = null;
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isSending) return;

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
        _selectedImageName = pickedFile.name;
      });
    }
  }

  Future<void> _deleteChatMessage(int index) async {
    await _localStorageService.deleteChatMessage(index);
    setState(() {
      _messages.removeAt(index);
    });
  }

  Future<void> _deleteAllChatMessages() async {
    await _localStorageService.deleteAllChatMessages();
    setState(() {
      _messages.clear();
    });
  }

  void _addMessageToChat(String text, MessageType type) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          timestamp: DateTime.now(),
          isUser: type == MessageType.sent,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreenUI(
      title: widget.title,
      themeManager: widget.themeManager,
      messages: _messages,
      textController: _textController,
      selectedImage: _selectedImage,
      selectedImageName: _selectedImageName,
      isSending: _isSending,
      sendMessage: _sendMessage,
      pickImage: _pickImage,
      deleteChatMessage: _deleteChatMessage,
      deleteAllChatMessages: _deleteAllChatMessages,
    );
  }
}