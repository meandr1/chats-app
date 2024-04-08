import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/model/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;

class ChatsList extends StatelessWidget {
  final List<Conversation>? conversations;
  final void Function(String uid) onChatTap;

  const ChatsList(
      {super.key, required this.conversations, required this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(color: Colors.grey),
            ),
        itemCount: conversations != null ? conversations!.length : 0,
        itemBuilder: (BuildContext context, int index) {
          final photoURL = conversations![index].companionPhotoURL;
          final subtitle = conversations![index].lastMessage;
          return ListTile(
            onTap: () => onChatTap(conversations![index].companionUID),
            leading: photoURL != null && photoURL.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: photoURL,
                    imageBuilder: (context, imageProvider) => Container(
                        width: constants.imageDiameterSmall,
                        height: constants.imageDiameterSmall,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover))),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/broken_image.png'))
                : const Icon(
                    size: constants.imageDiameterSmall,
                    constants.defaultPersonIcon,
                    color: constants.iconsColor),
            title: Text(conversations![index].companionName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: AutoSizeText(subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                minFontSize: 12,
                maxFontSize: 12),
            dense: true,
          );
        });
  }
}
