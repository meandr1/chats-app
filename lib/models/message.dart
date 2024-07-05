import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 3)
class Message {
  @HiveField(0)
  String sender;
  @HiveField(1)
  String text;
  @HiveField(2)
  String type;
  @HiveField(3)
  Timestamp? timestamp;
  @HiveField(4)
  String status;
  Message(
      {required this.sender,
      required this.text,
      required this.type,
      this.timestamp,
      required this.status});

  factory Message.fromJSON(Map<String, dynamic> jsonData) {
    return Message(
        sender: jsonData['sender'],
        type: jsonData['type'],
        text: jsonData['text'],
        status: jsonData['status'],
        timestamp: jsonData['timestamp']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'sender': sender,
      'text': text,
      'type': type,
      'status': status,
      'timestamp': FieldValue.serverTimestamp()
    };
  }
}
