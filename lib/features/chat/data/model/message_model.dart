import 'package:hive/hive.dart';
import '../../domain/entities/message.dart';

part 'message_model.g.dart';

@HiveType(typeId: 3)
enum MessageStatusHive {
  @HiveField(0)
  sending,
  @HiveField(1)
  sent,
  @HiveField(2)
  error,
}

@HiveType(typeId: 4)
class MessageModel extends Message {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final MessageStatusHive hiveStatus;

  MessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.hiveStatus = MessageStatusHive.sent,
  }) : super(
    id: id,
    text: text,
    isUser: isUser,
    timestamp: timestamp,
    status: _mapToDomainStatus(hiveStatus),
  );

  // Convert giữa Hive enum <-> Domain enum
  static MessageStatus _mapToDomainStatus(MessageStatusHive status) {
    switch (status) {
      case MessageStatusHive.sending:
        return MessageStatus.sending;
      case MessageStatusHive.error:
        return MessageStatus.error;
      default:
        return MessageStatus.sent;
    }
  }

  static MessageStatusHive mapToHiveStatus(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return MessageStatusHive.sending;
      case MessageStatus.error:
        return MessageStatusHive.error;
      default:
        return MessageStatusHive.sent;
    }
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      hiveStatus: MessageStatusHive.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => MessageStatusHive.sent,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'status': hiveStatus.name,
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      text: text,
      isUser: isUser,
      timestamp: timestamp,
      status: _mapToDomainStatus(hiveStatus),
    );
  }

  static MessageModel fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
      hiveStatus: mapToHiveStatus(message.status),
    );
  }
}
