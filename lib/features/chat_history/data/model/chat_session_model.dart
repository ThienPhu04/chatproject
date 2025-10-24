import 'package:hive/hive.dart';
import '../../domain/entities/chat_session.dart';

part 'chat_session_model.g.dart';

@HiveType(typeId: 1)
class ChatSessionModel extends ChatSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> messageIds;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  ChatSessionModel({
    required this.id,
    required this.title,
    required this.messageIds,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
    id: id,
    title: title,
    messageIds: messageIds,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    return ChatSessionModel(
      id: json['id'],
      title: json['title'],
      messageIds: List<String>.from(json['messageIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messageIds': messageIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ChatSessionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ChatSessionModel(
      id: id,
      title: data['title'] ?? 'New Chat',
      messageIds: List<String>.from(data['messageIds'] ?? []),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'messageIds': messageIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}