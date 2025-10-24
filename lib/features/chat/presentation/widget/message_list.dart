import 'package:finalproject/features/chat/domain/entities/message.dart';
import 'package:finalproject/features/chat/presentation/widget/message_bubble.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  const MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(message: messages[index]);
      },
    );
  }
}