abstract class FirebaseUser {
  static Map<String, Map<String, String>> updateUserInfo(
      {String? firstName,
      String? lastName,
      String? email,
      String? phoneNumber,
      String? photoURL}) {
    return {
      "userInfo": {
        if (firstName != null) "firstName": firstName,
        if (lastName != null) "lastName": lastName,
        if (email != null) "email": email,
        if (phoneNumber != null) "phoneNumber": phoneNumber,
        if (photoURL != null) "photoURL": photoURL,
      }
    };
  }

  static Map<String, Map<String, dynamic>> updateConversation(
      {required String chattingWithUID, String? name, String? lastMessage}) {
    return {
      "conversations": {
        chattingWithUID: {
          "name": name ?? '',
          "lastMessage": lastMessage ?? '',
          "timestamp": DateTime.now().microsecondsSinceEpoch,
          "unreadMessages": 4,
        }
      }
    };
  }
}
