import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  String? firstName;
  String? provider;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? photoURL;
  GeoPoint? location;
  UserInfo(
      {this.firstName,
      this.provider,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.photoURL,
      this.location});

  factory UserInfo.fromJSON(Map<String, dynamic> jsonData) {
    return UserInfo(
      firstName: jsonData['firstName'],
      provider: jsonData['provider'],
      lastName: jsonData['lastName'],
      email: jsonData['email'],
      phoneNumber: jsonData['phoneNumber'],
      photoURL: jsonData['photoURL'],
      location: jsonData['location'],
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
      if (location != null) "location": location.toString(),
    };
  }
}
