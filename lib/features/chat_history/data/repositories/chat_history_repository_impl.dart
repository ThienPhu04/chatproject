import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat/data/model/message_model.dart';
import '../../../chat/domain/entities/message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/repositories/chat_history_repository.dart';
import '../datasources/chat_history_local_datasource.dart';
import '../datasources/chat_history_remote_datasource.dart';

class ChatHistoryRepositoryImpl implements ChatHistoryRepository {
  final ChatHistoryLocalDataSource localDataSource;
  final ChatHistoryRemoteDataSource remoteDataSource;
  final firebase_auth.FirebaseAuth auth;
  final SharedPreferences prefs;

  static const String _currentSessionKey = 'current_session_id';

  ChatHistoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.auth,
    required this.prefs,
  });

  bool get _isLoggedIn => auth.currentUser != null;

  @override
  Future<List<ChatSession>> getAllSessions() async {
    if (_isLoggedIn) {
      return await remoteDataSource.getAllSessions();
    } else {
      return await localDataSource.getAllSessions();
    }
  }

  @override
  Future<ChatSession> createSession() async {
    final session = _isLoggedIn
        ? await remoteDataSource.createSession()
        : await localDataSource.createSession();

    await setCurrentSession(session.id);
    return session;
  }

  @override
  Future<void> updateSessionTitle(String sessionId, String newTitle) async {
    if (_isLoggedIn) {
      await remoteDataSource.updateSessionTitle(sessionId, newTitle);
    } else {
      await localDataSource.updateSessionTitle(sessionId, newTitle);
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    if (_isLoggedIn) {
      await remoteDataSource.deleteSession(sessionId);
    } else {
      await localDataSource.deleteSession(sessionId);
    }

    // Clear current session if deleted
    final currentSessionId = prefs.getString(_currentSessionKey);
    if (currentSessionId == sessionId) {
      await prefs.remove(_currentSessionKey);
    }
  }

  @override
  Future<void> saveMessage(String sessionId, Message message) async {
    final messageModel = MessageModel(
      id: message.id,
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
      hiveStatus: MessageModel.mapToHiveStatus(message.status),
    );

    if (_isLoggedIn) {
      await remoteDataSource.saveMessage(sessionId, messageModel);
    } else {
      await localDataSource.saveMessage(sessionId, messageModel);
    }
  }

  @override
  Future<List<Message>> getSessionMessages(String sessionId) async {
    if (_isLoggedIn) {
      return await remoteDataSource.getSessionMessages(sessionId);
    } else {
      return await localDataSource.getSessionMessages(sessionId);
    }
  }

  @override
  Future<ChatSession?> getCurrentSession() async {
    final sessionId = prefs.getString(_currentSessionKey);
    if (sessionId == null) return null;

    final sessions = await getAllSessions();
    try {
      return sessions.firstWhere((s) => s.id == sessionId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setCurrentSession(String? sessionId) async {
    if (sessionId == null) {
      await prefs.remove(_currentSessionKey);
    } else {
      await prefs.setString(_currentSessionKey, sessionId);
    }
  }

}