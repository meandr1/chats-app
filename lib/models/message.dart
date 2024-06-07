import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sender;
  String text;
  Timestamp? timestamp;
  String status;
  Message(
      {required this.sender,
      required this.text,
      this.timestamp,
      required this.status});

  factory Message.fromJSON(Map<String, dynamic> jsonData) {
    return Message(
        sender: jsonData['sender'],
        text: jsonData['text'],
        status: jsonData['status'],
        timestamp: jsonData['timestamp']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'sender': sender,
      'text': text,
      'status': status,
      'timestamp': FieldValue.serverTimestamp()
    };
  }
}
