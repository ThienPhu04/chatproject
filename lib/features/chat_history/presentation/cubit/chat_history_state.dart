import 'package:finalproject/features/chat/domain/entities/message.dart';

import '../../domain/entities/chat_session.dart';

abstract class ChatHistoryState {}

class ChatHistoryInitial extends ChatHistoryState {}

class ChatHistoryLoading extends ChatHistoryState {}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<ChatSession> sessions;
  final String? currentSessionId;
  final List<Message> currentMessages;

  ChatHistoryLoaded(this.sessions, {this.currentSessionId, required this.currentMessages});
}

class ChatHistoryError extends ChatHistoryState {
  final String message;
  ChatHistoryError(this.message);
}