import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUser {
  final String uid;
  final UserInfo userInfo;
  final List<Conversation> conversations;

  FirebaseUser(
      {required this.uid, required this.userInfo, required this.conversations});

  factory FirebaseUser.fromJSON(
      {required Map<String, dynamic> jsonData, required String uid}) {
    final userInfo = UserInfo.fromJSON(jsonData['userInfo']);

    Map<String, dynamic>? jsonOfConversations = jsonData['conversations'];
    List<Conversation> conversations = [];
    if (jsonOfConversations != null) {
      jsonOfConversations.entries
          .toList()
          .forEach((entry) => conversations.add(Conversation.fromJSON(entry)));
    }
    return FirebaseUser(
        uid: uid, userInfo: userInfo, conversations: conversations);
  }

  factory FirebaseUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final id = snapshot.id;
    final userInfo = UserInfo.fromJSON(data?['userInfo']);

    Map<String, dynamic>? jsonOfConversations = data?['conversations'];
    List<Conversation> conversations = [];
    if (jsonOfConversations != null) {
      jsonOfConversations.entries
          .toList()
          .forEach((entry) => conversations.add(Conversation.fromJSON(entry)));
    }
    return FirebaseUser(
        uid: id, userInfo: userInfo, conversations: conversations);
  }

  Map<String, dynamic> toJSON() {
    return {
      uid: {
        'userInfo': userInfo.toJSON(),
        'conversations': {
          conversations.map((element) => element.toJSON()).join(', ')
        }
      }
    };
  }
}

class UserInfo {
  String? firstName;
  String? provider;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? photoURL;
  UserInfo(
      {this.firstName,
      this.provider,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.photoURL});

  factory UserInfo.fromJSON(Map<String, dynamic> jsonData) {
    return UserInfo(
      firstName: jsonData['firstName'],
      provider: jsonData['provider'],
      lastName: jsonData['lastName'],
      email: jsonData['email'],
      phoneNumber: jsonData['phoneNumber'],
      photoURL: jsonData['photoURL'],
    );
  }

  Map<String, String?> toJSON() {
    return {
      if (provider != null) "provider": provider,
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
      if (email != null) "email": email,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (photoURL != null) "photoURL": photoURL,
    };
  }
}

class Conversation {
  String companionUID;
  String companionName;
  String lastMessage;
  int? unreadMessages;
  int? timestamp;
  Conversation(
      {required this.companionUID,
      required this.companionName,
      required this.lastMessage,
      this.unreadMessages,
      this.timestamp});

  factory Conversation.fromJSON(MapEntry<String, dynamic> jsonData) {
    final String companionUID = jsonData.key;
    final Map<String, dynamic> conversationData = jsonData.value;
    return Conversation(
        companionUID: companionUID,
        companionName: conversationData['companionName'],
        lastMessage: conversationData['lastMessage'],
        unreadMessages: conversationData['unreadMessages'],
        timestamp: conversationData['timestamp']);
  }

  Map<String, Map<String, dynamic>> toJSON() {
    return {
      companionUID: {
        "companionName": companionName,
        "lastMessage": lastMessage,
        "timestamp": DateTime.now().microsecondsSinceEpoch,
        "unreadMessages": unreadMessages ?? 0,
      }
    };
  }
}
