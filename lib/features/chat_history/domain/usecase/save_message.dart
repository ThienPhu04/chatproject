import '../../../chat/domain/entities/message.dart';
import '../repositories/chat_history_repository.dart';

class SaveMessage {
  final ChatHistoryRepository repository;
  SaveMessage(this.repository);
  Future<void> call(String sessionId, Message message) =>
      repository.saveMessage(sessionId, message);
}