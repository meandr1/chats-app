import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ChatsList extends StatelessWidget {
  final List<ConversationLayout>? conversations;
  final void Function(
      {required String companionID,
      required String conversationID,
      required String companionName,
      required String companionPhotoURL}) onChatTap;
  final void Function(
      {required String companionID,
      required String conversationID}) onChatDelete;

  const ChatsList(
      {super.key,
      this.conversations,
      required this.onChatTap,
      required this.onChatDelete});

  @override
  Widget build(BuildContext context) {
    if (conversations != null) {
      conversations!.sort((a, b) {
        if (a.timestamp == null && b.timestamp == null) {
          return 0;
        } else if (a.timestamp == null) {
          return -1;
        } else if (b.timestamp == null) {
          return 1;
        } else {
          return b.timestamp!.compareTo(a.timestamp!);
        }
      });
      return SlidableAutoCloseBehavior(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(color: Colors.grey),
          ),
          itemCount: conversations!.length,
          itemBuilder: (BuildContext context, int index) {
            final photoURL = conversations![index].companionPhotoURL;
            final subtitle = conversations![index].lastMessage;
            final isVoiceMessage =
                conversations![index].messageType == AppConstants.voiceType;
            final isImage =
                conversations![index].messageType == AppConstants.imageType;
            return Slidable(
                key: Key(conversations![index].companionID),
                endActionPane: ActionPane(
                    extentRatio: 0.22,
                    motion: const DrawerMotion(),
                    dismissible: DismissiblePane(
                      key: Key(conversations![index].companionID),
                      onDismissed: () => onChatDelete(
                          companionID: conversations![index].companionID,
                          conversationID: conversations![index].conversationID),
                    ),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (context) => onChatDelete(
                              companionID: conversations![index].companionID,
                              conversationID:
                                  conversations![index].conversationID))
                    ]),
                child: ListTile(
                  onTap: () => onChatTap(
                      conversationID: conversations![index].conversationID,
                      companionID: conversations![index].companionID,
                      companionPhotoURL:
                          conversations![index].companionPhotoURL ?? '',
                      companionName: conversations![index].companionName),
                  leading: photoURL != null && photoURL.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: photoURL,
                          imageBuilder: (context, imageProvider) => Container(
                              width: AppConstants.imageDiameterSmall,
                              height: AppConstants.imageDiameterSmall,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover))),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/broken_image.png'))
                      : const Icon(
                          size: AppConstants.imageDiameterSmall,
                          AppConstants.defaultPersonIcon,
                          color: AppConstants.iconsColor),
                  title: Text(conversations![index].companionName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: AutoSizeText(
                      isVoiceMessage ? 'Voice message' :  isImage ? 'Photo message': subtitle ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 12,
                      maxFontSize: 12),
                  trailing: Column(
                    children: [
                      getTimeWidget(conversations![index].timestamp),
                      getUnreadMessagesWidget(
                          conversations![index].unreadMessages ?? 0)
                    ],
                  ),
                  dense: true,
                ));
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getUnreadMessagesWidget(int messageCount) {
    if (messageCount > 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: AppConstants.unreadMessagesCircleDia,
          width: AppConstants.unreadMessagesCircleDia,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppConstants.unreadMessagesCircleColor),
          child: Center(child: Text(messageCount.toString())),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getTimeWidget(Timestamp? timestamp) {
    if (timestamp == null) {
      return const SizedBox.shrink();
    }
    final now = DateTime.now();
    final timestampDate = timestamp.toDate();
    if (timestampDate.isAfter(DateTime(now.year, now.month, now.day))) {
      return Text(DateFormat('HH:mm').format(timestampDate));
    } else if (timestampDate.isAfter(now.subtract(const Duration(days: 6)))) {
      return Text(DateFormat('EEE').format(timestampDate));
    } else if (timestampDate.isAfter(DateTime(now.year))) {
      return Text(DateFormat('dd MMM').format(timestampDate));
    } else {
      return Text(DateFormat('dd MMM yy').format(timestampDate));
    }
  }
}
