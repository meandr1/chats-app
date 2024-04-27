class ChatsScreenArgsTransferObject {
  final String? conversationID;
  final String companionID;
  final String companionName;
  final String companionPhotoURL;

  ChatsScreenArgsTransferObject(
      {this.conversationID,
      required this.companionID,
      required this.companionName,
      required this.companionPhotoURL});
}

class FindUsersScreenArgsTransferObject {
  final String companionUID;
  final String companionName;
  final String companionPhotoURL;
  final void Function() onBackButtonPress;

  FindUsersScreenArgsTransferObject(
      {required this.companionUID,
      required this.companionName,
      required this.companionPhotoURL,
      required this.onBackButtonPress});
}
