// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_layout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationLayoutAdapter extends TypeAdapter<ConversationLayout> {
  @override
  final int typeId = 1;

  @override
  ConversationLayout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationLayout(
      companionID: fields[1] as String,
      conversationID: fields[0] as String,
      companionName: fields[2] as String,
      messageType: fields[5] as String,
      companionPhotoURL: fields[3] as String?,
      lastMessage: fields[4] as String?,
      unreadMessages: fields[6] as int?,
      timestamp: fields[7] as Timestamp?,
    );
  }

  @override
  void write(BinaryWriter writer, ConversationLayout obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.conversationID)
      ..writeByte(1)
      ..write(obj.companionID)
      ..writeByte(2)
      ..write(obj.companionName)
      ..writeByte(3)
      ..write(obj.companionPhotoURL)
      ..writeByte(4)
      ..write(obj.lastMessage)
      ..writeByte(5)
      ..write(obj.messageType)
      ..writeByte(6)
      ..write(obj.unreadMessages)
      ..writeByte(7)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationLayoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final typeId = 2;

  @override
  Timestamp read(BinaryReader reader) {
    final micros = reader.readInt();
    return Timestamp.fromMicrosecondsSinceEpoch(micros);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    writer.writeInt(obj.microsecondsSinceEpoch);
  }
}
