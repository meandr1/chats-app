import 'package:auto_size_text/auto_size_text.dart';
import 'package:chats/feature/common_widgets/get_avatar_widget.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      conversations!.sort(nullableSort);
      return SlidableAutoCloseBehavior(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(color: Colors.grey),
          ),
          itemCount: conversations!.length,
          itemBuilder: (BuildContext context, int index) {
            final photoUrl = conversations![index].companionPhotoURL;
            final subtitle = _getSubtitle(conversations![index]);
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
                  leading: FutureBuilder(
                      future: context.read<HomeCubit>().getFile(photoUrl),
                      builder: (_, snapshot) => getAvatarWidget(
                          noAvatarIcon: AppConstants.defaultPersonIcon,
                          snapshot: snapshot,
                          photoUrl: photoUrl,
                          diameter: AppConstants.imageDiameterSmall)),
                  title: Text(conversations![index].companionName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: AutoSizeText(subtitle,
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

  int nullableSort(ConversationLayout a, ConversationLayout b) {
    if (a.timestamp == null && b.timestamp == null) {
      return 0;
    } else if (a.timestamp == null) {
      return -1;
    } else if (b.timestamp == null) {
      return 1;
    } else {
      return b.timestamp!.compareTo(a.timestamp!);
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

  String _getSubtitle(ConversationLayout conversationLayout) {
    final text = conversationLayout.lastMessage;
    final type = conversationLayout.messageType;
    return type == AppConstants.voiceType
        ? 'Voice message'
        : type == AppConstants.imageType
            ? 'Photo message'
            : type == AppConstants.videoType
                ? 'Video message'
                : text ?? '';
  }
}
