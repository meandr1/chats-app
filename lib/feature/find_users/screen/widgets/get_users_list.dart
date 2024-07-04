import 'package:chats/feature/common_widgets/get_avatar_widget.dart';
import 'package:chats/feature/find_users/cubit/find_users_cubit.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersList extends StatelessWidget {
  final List<FirebaseUser>? users;
  final void Function(
      {String? conversationID,
      required String companionID,
      required String companionName,
      required String companionPhotoURL}) onTap;
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
          String? photoUrl = users?[index].userInfo.photoURL;
          return ListTile(
              onTap: () => onTap(
                  conversationID: context
                      .read<FindUsersCubit>()
                      .getConversationID(users![index].conversations),
                  companionID: users![index].uid,
                  companionPhotoURL: users![index].userInfo.photoURL!,
                  companionName:
                      '${users![index].userInfo.firstName} ${users![index].userInfo.lastName}'),
              leading: FutureBuilder(
                  future: context.read<HomeCubit>().getFile(photoUrl),
                  builder: (_, snapshot) => getAvatarWidget(
                      noAvatarIcon: AppConstants.defaultPersonIcon,
                      snapshot: snapshot,
                      photoUrl: photoUrl,
                      diameter: AppConstants.imageDiameterSmall)),
              title: Text(
                  "${users?[index].userInfo.firstName} ${users?[index].userInfo.lastName}",
                  style: const TextStyle(fontSize: 20)));
        });
  }
}
