import '../entities/chat_session.dart';
import '../repositories/chat_history_repository.dart';

class GetAllSessions {
  final ChatHistoryRepository repository;
  GetAllSessions(this.repository);
  Future<List<ChatSession>> call() => repository.getAllSessions();
}