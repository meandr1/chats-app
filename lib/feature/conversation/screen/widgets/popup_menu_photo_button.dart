import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/cubits/images_cubit/images_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupMenuPhotoButton extends StatefulWidget {
  const PopupMenuPhotoButton({super.key});

  @override
  State<StatefulWidget> createState() => _PopupMenuPhotoButtonState();
}

enum Items { photo, gallery }

class _PopupMenuPhotoButtonState extends State<PopupMenuPhotoButton> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ImagesCubit, ImagesState>(
      listener: (context, state) {
        if (state.status == ImagesStatus.loadingSuccess) {
          context
              .read<ConversationCubit>()
              .sendFile(fileUrl: state.fileUrl!, type: AppConstants.imageType);
        }
      },
      child: PopupMenuButton<Items>(
        color: Colors.white,
        child: const Icon(Icons.attach_file, color: Colors.white),
        onSelected: (Items item) {
          if (item == Items.gallery) {
            context.read<ImagesCubit>().pickFile();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Items>>[
          const PopupMenuItem<Items>(
            value: Items.photo,
            child: ListTile(
              leading: Icon(Icons.photo_camera_outlined),
              title: Text('Take a photo'),
            ),
          ),
          const PopupMenuItem<Items>(
            value: Items.gallery,
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
