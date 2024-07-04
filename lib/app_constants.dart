import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
export 'package:chats/app_constants.dart';

enum PopupMenuPhotoButtonItems { photo, video, gallery }

abstract class AppConstants {
  // Asset paths
  static const String sendEmailAsset = 'assets/images/send_mail.png';
  static const String googleLogoAsset = 'assets/images/google_logo.png';
  static const String facebookLogoAsset = 'assets/images/facebook.png';
  static const String chatsAppLogoAsset = 'assets/images/chat_icon.png';
  static const String failedToLoadImageAsset = 'assets/images/broken_image.png';
  static const String failedToLoadChatImageAsset =
      'assets/images/broken_image2.png';
  static const String defaultGoogleMapPinAsset =
      'assets/images/google_maps_pin.png';

  // App colors
  static const Color textFormFieldColor = Color.fromARGB(255, 50, 74, 138);
  static const Color textButtonColor = Color.fromARGB(255, 50, 74, 138);
  static const Color elevatedButtonColor = Color.fromARGB(255, 98, 121, 183);
  static const Color iconsColor = Color.fromARGB(255, 98, 121, 183);
  static const Color appBarColor = Color.fromARGB(255, 139, 161, 221);
  static const Color bottomNavigationBarColor =
      Color.fromARGB(255, 98, 121, 183);

  // Verify email text
  static const String verifyEmailText =
      'Click the link in your email to verify your account. \nIf you cant find the email check your spam folder or\n';
  // Resend verify email letter clickable text
  static const String verifyEmailClickableText = 'click here to resend.';

  // Auth cubit unknown error message
  static const String unknownError = 'An unknown error occurred';
  // Message when loading video is failed
  static const String videoLoadFailed = 'Failed to load video';

  // The height of main logo on all screens except auth screen
  static const double mainLogoSmallSize = 50.0;

  // The diameter of personal profile avatar image
  static const double imageDiameterLarge = 150.0;
  // The diameter of avatar images on chats list and find users screen
  static const double imageDiameterSmall = 50.0;
  // The diameter of avatar images of conversation screen
  static const double conversationAvatarDia = 25.0;
  // The diameter of avatar images of conversation screen
  static const double recordingCancelSwipeDistance = 150.0;

  // Default icon of profile without photo
  static const IconData defaultPersonIcon = Icons.person;
  // Icon on User`s info screen to add photo
  static const IconData addPhotoIcon = Icons.photo_camera_outlined;

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
  static const String onGalleryPermissionNotGranted =
      'Cannot access to photo library';

  // The path to firebase storage where the users files is stored.
  static const String firebaseStorageURL =
      'https://firebasestorage.googleapis.com';

  // Types of messages
  static const String textType = 'text';
  static const String voiceType = 'voice';
  static const String imageType = 'image';
  static const String videoType = 'video';

  // Size and color of unread messages widget on main screen.
  static const double unreadMessagesCircleDia = 20;
  static const Color unreadMessagesCircleColor = Colors.blue;

  // Chat bubble style constants
  static const Color chatBubbleSentColor = Color.fromARGB(255, 80, 190, 250);
  static const Color chatBubbleReceivedColor =
      Color.fromARGB(255, 230, 230, 230);
  static const double chatBubbleHeightFactor = 0.8;
  static const double chatBubbleWidthFactor = 0.65;
  static const double waveBubbleWidthFactor = 0.45;
  static const double chatBubbleBorderRadius = 15;
  static const double chatBubbleMetaFontSize = 11.0;
  static const TextStyle chatBubbleTextStyle = TextStyle(
      color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w600);

  // Size of area before and after the visible area to cache items on conversation screen
  static const double cacheExtent = 1000;

  // Firebase paths
  // Users recordings collection path
  static const String userRecordingsCollection = 'recordings';
  // Users images collection path
  static const String userImagesCollection = 'images';
  // Users videos collection path
  static const String userVideosCollection = 'videos';
  // Users avatar collection path
  static const String userAvatarsCollection = 'avatars';
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

  // Hive paths
  // Users files collection path
  static const String localFilesCollection = 'files';
}
