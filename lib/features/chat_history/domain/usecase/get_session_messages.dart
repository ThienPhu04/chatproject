import '../../../chat/domain/entities/message.dart';
import '../repositories/chat_history_repository.dart';

class GetSessionMessages {
  final ChatHistoryRepository repository;
  GetSessionMessages(this.repository);
  Future<List<Message>> call(String sessionId) =>
      repository.getSessionMessages(sessionId);
}