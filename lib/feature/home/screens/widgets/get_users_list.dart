import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/model/firebase_user.dart';
import 'package:flutter/material.dart';

class UsersList {
  final List<FirebaseUser>? users;
  UsersList(this.users);

  ListView getUsersListView() {
    return ListView.separated(
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Divider(color: Colors.grey),
        ),
        itemCount: users != null ? users!.length : 0,
        itemBuilder: (BuildContext context, int index) {
          String? photoURL = users?[index].userInfo.photoURL;
          return ListTile(
              leading: photoURL != null && photoURL.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: photoURL,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person))
                  : const Icon(Icons.person),
              title: Text(
                  "${users?[index].userInfo.firstName} ${users?[index].userInfo.lastName}",
                  style: const TextStyle(fontSize: 20)));
        });
  }
}
