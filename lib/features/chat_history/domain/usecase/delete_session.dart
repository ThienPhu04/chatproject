import '../repositories/chat_history_repository.dart';

class DeleteSession {
  final ChatHistoryRepository repository;
  DeleteSession(this.repository);
  Future<void> call(String sessionId) => repository.deleteSession(sessionId);
}