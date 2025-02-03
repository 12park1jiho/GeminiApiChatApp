import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage { // 이렇게 수정
  @HiveField(0)
  final String text;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final bool isUser;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isUser,
  });
}