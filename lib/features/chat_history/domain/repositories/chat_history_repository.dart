import '../../../chat/domain/entities/message.dart';
import '../entities/chat_session.dart';

abstract class ChatHistoryRepository {
  Future<List<ChatSession>> getAllSessions();
  Future<ChatSession> createSession();
  Future<void> updateSessionTitle(String sessionId, String newTitle);
  Future<void> deleteSession(String sessionId);
  Future<void> saveMessage(String sessionId, Message message);
  Future<List<Message>> getSessionMessages(String sessionId);
  Future<ChatSession?> getCurrentSession();
  Future<void> setCurrentSession(String? sessionId);
}
