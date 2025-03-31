import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../utils/theme_manager.dart';
import '../widgets/message_bubble.dart';

class ChatScreenUI extends StatelessWidget {
  final String title;
  final ThemeManager themeManager;
  final List<ChatMessage> messages;
  final TextEditingController textController;
  final XFile? selectedImage;
  final String? selectedImageName;
  final bool isSending;
  final Future<void> Function(String) sendMessage;
  final Future<void> Function(ImageSource) pickImage;
  final Future<void> Function(int) deleteChatMessage;
  final Future<void> Function() deleteAllChatMessages;

  const ChatScreenUI({
    super.key,
    required this.title,
    required this.themeManager,
    required this.messages,
    required this.textController,
    required this.selectedImage,
    required this.selectedImageName,
    required this.isSending,
    required this.sendMessage,
    required this.pickImage,
    required this.deleteChatMessage,
    required this.deleteAllChatMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'AI Chat Menu',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('테마 변경'),
              onTap: () {
                if (themeManager.themeMode == ThemeMode.light) {
                  themeManager.changeTheme(ThemeMode.dark);
                } else if (themeManager.themeMode == ThemeMode.dark) {
                  themeManager.changeTheme(ThemeMode.system);
                } else {
                  themeManager.changeTheme(ThemeMode.light);
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('채팅 기록 삭제'),
              onTap: () {
                deleteAllChatMessages();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(  // ListView.builder를 Expanded로 감싸기
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return MessageBubble(
                    message: message,
                    onDelete: !message.isUser ? () => deleteChatMessage(index) : null,
                  );
                },
              ),
            ),
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildImage(selectedImage!.path),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: isSending
                      ? null
                      : () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('갤러리에서 선택'),
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('카메라로 촬영'),
                                onTap: () {
                                  pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      enabled: !isSending,
                    ),
                    onSubmitted: isSending ? null : sendMessage,
                    textInputAction: TextInputAction.send,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: isSending ? null : () => sendMessage(textController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return SizedBox(  // SizedBox로 감싸서 크기 제한
      height: 200,
      child: kIsWeb
          ? Image.network(
        imagePath,
        fit: BoxFit.cover,
      )
          : Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      ),
    );
  }
}