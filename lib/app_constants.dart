import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:chats/app_constants.dart';

abstract class AppConstants {
  // App colors
  static const Color textFormFieldColor = Color.fromARGB(255, 50, 74, 138);
  static const Color textButtonColor = Color.fromARGB(255, 50, 74, 138);
  static const Color elevatedButtonColor = Color.fromARGB(255, 98, 121, 183);
  static const Color iconsColor = Color.fromARGB(255, 98, 121, 183);
  static const Color appBarColor = Color.fromARGB(255, 139, 161, 221);
  static const Color bottomNavigationBarColor =
      Color.fromARGB(255, 98, 121, 183);

  // Auth cubit unknown error message
  static const String unknownError = 'An unknown error occurred';

  // The height of main logo on all screens except auth screen
  static const double mainLogoSmallSize = 50.0;

  // Max shown message length on main screen
  static const int maxShownMessageLength = 80;

  // The diameter of avatar images on chats list and find users screen
  static const double imageDiameterSmall = 50.0;
  // The diameter of avatar images of conversation screen
  static const double conversationAvatarDia = 25.0;
  // The diameter of personal profile avatar image
  static const double imageDiameterLarge = 150.0;

  // Default icon of profile without photo
  static const IconData defaultPersonIcon = Icons.person;

  // Max shown message length on main screen
  static const double defaultButtonHigh = 40;

  // Auth providers names
  static const String emailProvider = 'email';
  static const String phoneProvider = 'phone';
  static const String googleProvider = 'google.com';
  static const String facebookProvider = 'facebook.com';

  // Messages of Flush and Snack bars
  static const String onPassResetLinkSend =
      'Password reset link was send. Check your email.';
  static const String onResendVerifyLetter =
      'We\'ve resend email one more time';
  static const String onFillUserInfo =
      'Before you getting started fill personal info is necessary';
  static const String onPermissionNotGranted = 'Cannot access to photo library';
  static const String userInfoError =
      'Error occurred during updating profile data';

  // The path to firebase storage where the users avatars is stored.
  static const String firebaseStorageURL =
      'https://firebasestorage.googleapis.com';

  // Size and color of unread messages widget on main screen.
  static const double unreadMessagesCircleDia = 20;
  static const Color unreadMessagesCircleColor = Colors.blue;

  // Chat bubble style constants
  static const Color chatBubbleSentColor = Color.fromARGB(255, 80, 190, 250);
  static const Color chatBubbleReceivedColor =
      Color.fromARGB(255, 230, 230, 230);
  static const double chatBubbleBorderRadius = 15;
  static const double chatBubbleMetaFontSize = 11.0;
  static const TextStyle chatBubbleTextStyle = TextStyle(
      color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w600);

  // Firebase paths
  // Images collection path
  static const String imagesCollection = 'images';
  // Users collection and fields
  static const String usersCollection = 'users';
  static const String conversationsField = 'conversations';
  static const String userInfoField = 'userInfo';
  static const String locationField = 'location';
  // Firebase messages fields
  static const String messageTimestampField = 'timestamp';
  static const String messageSenderField = 'sender';
  static const String messageStatusField = 'status';
  static const String messageSentStatus = 'sent';
  static const String messageDeliveredStatus = 'delivered';
  static const String messageReadStatus = 'read';

  // Map constants
  // Default map camera position
  static const defaultCameraPosition =
      CameraPosition(target: LatLng(49, 31), zoom: 5);
  // Default map camera zoom level on focus on user location
  static const double defaultZoomLevel = 14;
  // The diameter of avatar images on google map
  static const double mapImageDiameter = 40.0;
  
}
