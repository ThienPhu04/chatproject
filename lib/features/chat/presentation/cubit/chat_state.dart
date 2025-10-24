import '../../domain/entities/message.dart';
import '../../domain/entities/suggestion.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {
  final List<Suggestion> suggestions;
  ChatInitial(this.suggestions);
}

class ChatLoading extends ChatState {
  final List<Message> messages;
  ChatLoading(this.messages);
}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;
  final List<Message> messages;
  ChatError(this.message, this.messages);
}