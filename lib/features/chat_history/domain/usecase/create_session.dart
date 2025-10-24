import '../entities/chat_session.dart';
import '../repositories/chat_history_repository.dart';

class CreateSession {
  final ChatHistoryRepository repository;
  CreateSession(this.repository);
  Future<ChatSession> call() => repository.createSession();
}