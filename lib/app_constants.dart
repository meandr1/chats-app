import 'package:flutter/material.dart';
export 'package:chats/app_constants.dart';
abstract class AppConstants {
// App colors
static const Color textFormFieldColor = Color.fromARGB(255, 50, 74, 138);
static const Color textButtonColor = Color.fromARGB(255, 50, 74, 138);
static const Color elevatedButtonColor = Color.fromARGB(255, 98, 121, 183);
static const Color iconsColor = Color.fromARGB(255, 98, 121, 183);
static const Color appBarColor = Color.fromARGB(255, 139, 161, 221);
static const Color bottomNavigationBarColor = Color.fromARGB(255, 98, 121, 183);

// auth cubit constants
static const String unknownError = 'An unknown error occurred';

// The height of main logo on all screens except auth screen
static const double mainLogoSmallSize = 50.0;

// Max shown message length on main screen
static const int maxShownMessageLength = 80;

// The diameter of avatar images
static const double imageDiameterSmall = 50.0;

// The diameter of personal profile avatar image
static const double imageDiameterLarge = 150.0;

// Default icon of profile without photo
static const IconData defaultPersonIcon = Icons.person;

// Max shown message length on main screen
static const double defaultButtonHigh = 40;

// Auth providers name
static const String emailProvider = 'email';
static const String phoneProvider = 'phone';
static const String googleProvider = 'google.com';
static const String facebookProvider = 'facebook.com';

// Messages of Flush and Snack bars
static const String onPassResetLinkSend = 'Password reset link was send. Check your email.';
static const String onResendVerifyLetter = 'We\'ve resend email one more time';
static const String onFillUserInfo = 'Before you getting started fill personal info is necessary';
static const String onPermissionNotGranted = 'Cannot access to photo library';
static const String userInfoError = 'Error occurred during updating profile data';

// The path to firebase storage where the users avatars is stored. 
static const String firebaseStorageURL = 'https://firebasestorage.googleapis.com';

// The path to firebase storage where the users avatars is stored. 
static const double unreadMessagesCircleDia = 20;
static const Color unreadMessagesCircleColor = Colors.blue;

}