import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  String text;
  String type;
  Timestamp? timestamp;
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
