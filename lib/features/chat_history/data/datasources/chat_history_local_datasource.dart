import 'package:hive/hive.dart';
import '../../../chat/data/model/message_model.dart';
import '../model/chat_session_model.dart';

abstract class ChatHistoryLocalDataSource {
  Future<List<ChatSessionModel>> getAllSessions();
  Future<ChatSessionModel> createSession();
  Future<void> updateSessionTitle(String sessionId, String newTitle);
  Future<void> deleteSession(String sessionId);
  Future<void> saveMessage(String sessionId, MessageModel message);
  Future<List<MessageModel>> getSessionMessages(String sessionId);
}

class ChatHistoryLocalDataSourceImpl implements ChatHistoryLocalDataSource {
  static const String _sessionsBoxName = 'chat_sessions';
  static const String _messagesBoxName = 'chat_messages';

  Future<Box<ChatSessionModel>> _getSessionsBox() async {
    if (!Hive.isBoxOpen(_sessionsBoxName)) {
      return await Hive.openBox<ChatSessionModel>(_sessionsBoxName);
    }
    return Hive.box<ChatSessionModel>(_sessionsBoxName);
  }

  Future<Box<MessageModel>> _getMessagesBox() async {
    if (!Hive.isBoxOpen(_messagesBoxName)) {
      return await Hive.openBox<MessageModel>(_messagesBoxName);
    }
    return Hive.box<MessageModel>(_messagesBoxName);
  }

  @override
  Future<List<ChatSessionModel>> getAllSessions() async {
    final box = await _getSessionsBox();
    return box.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<ChatSessionModel> createSession() async {
    final box = await _getSessionsBox();
    final now = DateTime.now();
    final session = ChatSessionModel(
      id: now.millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      messageIds: [],
      createdAt: now,
      updatedAt: now,
    );
    await box.put(session.id, session);
    return session;
  }

  @override
  Future<void> updateSessionTitle(String sessionId, String newTitle) async {
    final box = await _getSessionsBox();
    final session = box.get(sessionId);
    if (session != null) {
      final updated = ChatSessionModel(
        id: session.id,
        title: newTitle,
        messageIds: session.messageIds,
        createdAt: session.createdAt,
        updatedAt: DateTime.now(),
      );
      await box.put(sessionId, updated);
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final sessionsBox = await _getSessionsBox();
    final messagesBox = await _getMessagesBox();

    final session = sessionsBox.get(sessionId);
    if (session != null) {
      // Delete all messages
      for (var messageId in session.messageIds) {
        await messagesBox.delete(messageId);
      }
      // Delete session
      await sessionsBox.delete(sessionId);
    }
  }

  @override
  Future<void> saveMessage(String sessionId, MessageModel message) async {
    final sessionsBox = await _getSessionsBox();
    final messagesBox = await _getMessagesBox();

    // Save message
    await messagesBox.put(message.id, message);

    // Update session
    final session = sessionsBox.get(sessionId);
    if (session != null) {
      final updatedMessageIds = List<String>.from(session.messageIds)
        ..add(message.id);
      final updated = ChatSessionModel(
        id: session.id,
        title: session.title,
        messageIds: updatedMessageIds,
        createdAt: session.createdAt,
        updatedAt: DateTime.now(),
      );
      await sessionsBox.put(sessionId, updated);
    }
  }

  @override
  Future<List<MessageModel>> getSessionMessages(String sessionId) async {
    final sessionsBox = await _getSessionsBox();
    final messagesBox = await _getMessagesBox();

    final session = sessionsBox.get(sessionId);
    if (session == null) return [];

    final messages = <MessageModel>[];
    for (var messageId in session.messageIds) {
      final message = messagesBox.get(messageId);
      if (message != null) {
        messages.add(message);
      }
    }
    return messages;
  }
}