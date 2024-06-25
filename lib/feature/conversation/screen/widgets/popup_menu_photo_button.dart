import 'package:flutter/material.dart';

class PopupMenuPhotoButton extends StatefulWidget {
  const PopupMenuPhotoButton({super.key});

  @override
  State<StatefulWidget> createState() => _PopupMenuPhotoButtonState();
}

enum Items { photo, gallery }

class _PopupMenuPhotoButtonState extends State<PopupMenuPhotoButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Items>(
      color: Colors.white,
      child: const Icon(Icons.attach_file, color: Colors.white),
      onSelected: (Items item) {
        // setState(() {

        // });
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
    );
  }
}
