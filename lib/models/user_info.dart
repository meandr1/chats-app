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
