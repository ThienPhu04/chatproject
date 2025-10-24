import '../repositories/chat_history_repository.dart';

class UpdateSessionTitle {
  final ChatHistoryRepository repository;
  UpdateSessionTitle(this.repository);
  Future<void> call(String sessionId, String newTitle) =>
      repository.updateSessionTitle(sessionId, newTitle);
}