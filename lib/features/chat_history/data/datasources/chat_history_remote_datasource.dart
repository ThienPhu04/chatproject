import 'package:firebase_auth/firebase_auth.dart';
import '../../../chat/data/model/message_model.dart';
import '../model/chat_session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatHistoryRemoteDataSource {
  Future<List<ChatSessionModel>> getAllSessions();
  Future<ChatSessionModel> createSession();
  Future<void> updateSessionTitle(String sessionId, String newTitle);
  Future<void> deleteSession(String sessionId);
  Future<void> saveMessage(String sessionId, MessageModel message);
  Future<List<MessageModel>> getSessionMessages(String sessionId);
}

class ChatHistoryRemoteDataSourceImpl implements ChatHistoryRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatHistoryRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _sessionsCollection {
    if (_userId == null) throw Exception('User not authenticated');
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('chat_sessions');
  }

  CollectionReference _messagesCollection(String sessionId) {
    return _sessionsCollection.doc(sessionId).collection('messages');
  }

  @override
  Future<List<ChatSessionModel>> getAllSessions() async {
    if (_userId == null) return [];

    final snapshot = await _sessionsCollection
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ChatSessionModel.fromFirestore(
      doc.data() as Map<String, dynamic>,
      doc.id,
    ))
        .toList();
  }

  @override
  Future<ChatSessionModel> createSession() async {
    if (_userId == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final docRef = _sessionsCollection.doc();

    final session = ChatSessionModel(
      id: docRef.id,
      title: 'New Chat',
      messageIds: [],
      createdAt: now,
      updatedAt: now,
    );

    await docRef.set(session.toFirestore());
    return session;
  }

  @override
  Future<void> updateSessionTitle(String sessionId, String newTitle) async {
    if (_userId == null) return;

    await _sessionsCollection.doc(sessionId).update({
      'title': newTitle,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    if (_userId == null) return;

    // Delete all messages in subcollection
    final messagesSnapshot = await _messagesCollection(sessionId).get();
    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete session
    await _sessionsCollection.doc(sessionId).delete();
  }

  @override
  Future<void> saveMessage(String sessionId, MessageModel message) async {
    if (_userId == null) return;

    // Save message
    await _messagesCollection(sessionId).doc(message.id).set(message.toJson());

    // Update session's updatedAt
    await _sessionsCollection.doc(sessionId).update({
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<List<MessageModel>> getSessionMessages(String sessionId) async {
    if (_userId == null) return [];

    final snapshot = await _messagesCollection(sessionId)
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
