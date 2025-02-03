import 'package:flutter/material.dart';
import '../chat/chat_message.dart';
import '../manager/api_manager.dart';
import '../manager/theme_manager.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title, required this.themeManager});
  final String title;
  final ThemeManager themeManager;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  late final ApiManager _apiManager;

  @override
  void initState() {
    super.initState();
    _apiManager = ApiManager();
    _initializeChatBox();
  }

  Future<void> _initializeChatBox() async {
    await _apiManager.initializeChatBox();
    _loadChatMessages();
  }

  Future<void> _loadChatMessages() async {
    final messages = _apiManager.getChatMessages();
    setState(() {
      _messages.addAll(messages);
    });
  }

  Future<void> _addChatMessage(String text, bool isUser) async {
    final message = ChatMessage(
      text: text,
      timestamp: DateTime.now(),
      isUser: isUser,
    );
    await _apiManager.addChatMessage(message);
    setState(() {
      _messages.add(message);
    });
  }

  Future<void> _deleteChatMessage(int index) async {
    await _apiManager.deleteChatMessage(index);
    setState(() {
      _messages.removeAt(index);
    });
  }

  Future<void> _deleteAllChatMessages() async {
    await _apiManager.deleteAllChatMessages();
    setState(() {
      _messages.clear();
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return; // 빈 메시지 전송 방지
    _addChatMessage(text, true);
    final response = await _apiManager.sendMessageToGemini(text);
    _addChatMessage(response, false);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
                if (widget.themeManager.themeMode == ThemeMode.light) {
                  widget.themeManager.changeTheme(ThemeMode.dark);
                } else if (widget.themeManager.themeMode == ThemeMode.dark) {
                  widget.themeManager.changeTheme(ThemeMode.system);
                } else {
                  widget.themeManager.changeTheme(ThemeMode.light);
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('채팅 기록 삭제'),
              onTap: () {
                _deleteAllChatMessages();
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
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Row(
                    mainAxisAlignment: message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.text,
                              style: TextStyle(
                                color: message.isUser
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              message.timestamp.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: message.isUser
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!message.isUser)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteChatMessage(index);
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                    ),
                    onSubmitted: _sendMessage, // 엔터 키로 메시지 전송
                    textInputAction: TextInputAction.send, // 키보드 엔터 키 모양 변경
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_textController.text), // 전송 버튼으로 메시지 전송
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}