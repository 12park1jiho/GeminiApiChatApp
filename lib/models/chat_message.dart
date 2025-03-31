import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String? text;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final String? image;

  ChatMessage({
    this.text,
    required this.timestamp,
    required this.isUser,
    this.image,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: json['isUser'] as bool,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
      'image': image,
    };
  }
}