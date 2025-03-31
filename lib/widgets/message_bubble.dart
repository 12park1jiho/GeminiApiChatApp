import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onDelete;

  const MessageBubble({super.key, required this.message, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.isUser;
    final backgroundColor = isUserMessage ? Colors.blue[100] : Colors.grey[200];
    final textColor = isUserMessage ? Colors.black : Colors.black;
    final crossAxisAlignment =
    isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isUserMessage ? 12 : 0),
      bottomRight: Radius.circular(isUserMessage ? 0 : 12),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ConstrainedBox(  // 추가된 부분: 메시지 버블의 최대 너비 제한
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), // 화면 너비의 70%로 제한 (조절 가능)
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.text != null && message.text!.isNotEmpty)
                    Text(
                      message.text!,
                      style: TextStyle(color: textColor),
                    ),
                  if (message.image != null)
                    _buildImage(message.image!),  // 이미지 표시
                ],
              ),
            ),
          ),
          if (!isUserMessage && onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, size: 16),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String image) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: 200,  // 고정된 너비
        height: 200,  // 고정된 높이
        child: kIsWeb
            ? Image.memory(
          base64Decode(image),
          width: 200,  // 고정된 너비
          height: 200,  // 고정된 높이
          fit: BoxFit.cover,
        )
            : Image.file(
          File(image),
          width: 200,  // 고정된 너비
          height: 200,  // 고정된 높이
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}