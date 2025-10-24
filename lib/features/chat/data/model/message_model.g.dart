// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 4;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      id: fields[0] as String,
      text: fields[1] as String,
      isUser: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      hiveStatus: fields[4] as MessageStatusHive,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isUser)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.hiveStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageStatusHiveAdapter extends TypeAdapter<MessageStatusHive> {
  @override
  final int typeId = 3;

  @override
  MessageStatusHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageStatusHive.sending;
      case 1:
        return MessageStatusHive.sent;
      case 2:
        return MessageStatusHive.error;
      default:
        return MessageStatusHive.sending;
    }
  }

  @override
  void write(BinaryWriter writer, MessageStatusHive obj) {
    switch (obj) {
      case MessageStatusHive.sending:
        writer.writeByte(0);
        break;
      case MessageStatusHive.sent:
        writer.writeByte(1);
        break;
      case MessageStatusHive.error:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatusHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
