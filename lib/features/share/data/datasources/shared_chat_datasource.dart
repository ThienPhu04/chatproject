import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../chat/data/model/message_model.dart';
import '../../../chat_history/data/model/chat_session_model.dart';

abstract class SharedChatDataSource {
  Future<String> createSharedChat(ChatSessionModel session, List<MessageModel> messages);
  Future<ChatSessionModel> getSharedSession(String shareId);
  Future<List<MessageModel>> getSharedMessages(String shareId);
}

class SharedChatDataSourceImpl implements SharedChatDataSource {
  final FirebaseFirestore _firestore;

  SharedChatDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _sharedChatsCollection =>
      _firestore.collection('shared_chats');

  @override
  Future<String> createSharedChat(
      ChatSessionModel session,
      List<MessageModel> messages,
      ) async {
    try {
      final docRef = _sharedChatsCollection.doc();
      final shareId = docRef.id;

      final messagesJson = messages.map((m) => m.toJson()).toList();

      await docRef.set({
        'sessionId': session.id,
        'title': session.title,
        'messages': messagesJson,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        'viewCount': 0,
      });

      return shareId;
    } catch (e) {
      throw Exception('Failed to create shared chat: $e');
    }
  }

  @override
  Future<ChatSessionModel> getSharedSession(String shareId) async {
    try {
      final doc = await _sharedChatsCollection.doc(shareId).get();

      if (!doc.exists) {
        throw Exception('Shared chat not found');
      }

      final data = doc.data() as Map<String, dynamic>;

      _incrementViewCount(shareId);

      return ChatSessionModel(
        id: data['sessionId'] as String,
        title: data['title'] as String,
        messageIds: [],
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get shared session: $e');
    }
  }

  @override
  Future<List<MessageModel>> getSharedMessages(String shareId) async {
    try {
      final doc = await _sharedChatsCollection.doc(shareId).get();

      if (!doc.exists) {
        throw Exception('Shared chat not found');
      }

      final data = doc.data() as Map<String, dynamic>;
      final messagesJson = data['messages'] as List<dynamic>;

      return messagesJson
          .map((json) => MessageModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get shared messages: $e');
    }
  }

  Future<void> _incrementViewCount(String shareId) async {
    try {
      await _sharedChatsCollection.doc(shareId).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      // Ignore error
    }
  }
}