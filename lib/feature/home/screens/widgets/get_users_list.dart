import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/model/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;

class UsersList extends StatelessWidget {
  final List<FirebaseUser>? users;
  final void Function(String uid) onTap;
  const UsersList({super.key, this.users, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(color: Colors.grey),
            ),
        itemCount: users != null ? users!.length : 0,
        itemBuilder: (BuildContext context, int index) {
          String? photoURL = users?[index].userInfo.photoURL;
          return ListTile(
              onTap: () => onTap(users![index].uid),
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
                      color: constants.iconsColor,),
              title: Text(
                  "${users?[index].userInfo.firstName} ${users?[index].userInfo.lastName}",
                  style: const TextStyle(fontSize: 20)));
        });
  }
}
