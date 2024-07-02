import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/cubits/media_cubit/media_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupMenuPhotoButton extends StatefulWidget {
  const PopupMenuPhotoButton({super.key});

  @override
  State<StatefulWidget> createState() => _PopupMenuPhotoButtonState();
}

class _PopupMenuPhotoButtonState extends State<PopupMenuPhotoButton> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaCubit, MediaState>(
      listener: (context, state) {
        if (state.status == MediaStatus.loadingSuccess) {
          context
              .read<ConversationCubit>()
              .sendFileMessage(fileUrl: state.fileUrl!, type: state.type!);
          context.read<MediaCubit>().clearState();
        }
      },
      child: PopupMenuButton<PopupMenuPhotoButtonItems>(
        color: Colors.white,
        child: const Icon(Icons.attach_file, color: Colors.white),
        onSelected: (PopupMenuPhotoButtonItems item) {
          context.read<MediaCubit>().pickFile(item: item, context: context);
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<PopupMenuPhotoButtonItems>>[
          const PopupMenuItem<PopupMenuPhotoButtonItems>(
            value: PopupMenuPhotoButtonItems.photo,
            child: ListTile(
              leading: Icon(Icons.photo_camera_outlined),
              title: Text('Take a photo'),
            ),
          ),
          const PopupMenuItem<PopupMenuPhotoButtonItems>(
            value: PopupMenuPhotoButtonItems.video,
            child: ListTile(
              leading: Icon(Icons.video_camera_back_outlined),
              title: Text('Record a video'),
            ),
          ),
          const PopupMenuItem<PopupMenuPhotoButtonItems>(
            value: PopupMenuPhotoButtonItems.gallery,
            child: ListTile(
              leading: Icon(Icons.image_search),
              title: Text('Chose from gallery'),
            ),
          ),
        ],
      ),
    );
  }
}
