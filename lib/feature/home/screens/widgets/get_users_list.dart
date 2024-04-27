import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/feature/home/cubits/find_users/find_users_cubit.dart';
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
          String? photoURL = users?[index].userInfo.photoURL;
          return ListTile(
              onTap: () => onTap(
                  conversationID: context
                      .read<FindUsersCubit>()
                      .getConversationID(users![index].conversations),
                  companionID: users![index].uid,
                  companionPhotoURL: users![index].userInfo.photoURL!,
                  companionName:
                      '${users![index].userInfo.firstName} ${users![index].userInfo.lastName}'),
              leading: photoURL != null && photoURL.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: photoURL,
                      imageBuilder: (context, imageProvider) => Container(
                          width: AppConstants.imageDiameterSmall,
                          height: AppConstants.imageDiameterSmall,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover))),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/broken_image.png'))
                  : const Icon(
                      size: AppConstants.imageDiameterSmall,
                      AppConstants.defaultPersonIcon,
                      color: AppConstants.iconsColor,
                    ),
              title: Text(
                  "${users?[index].userInfo.firstName} ${users?[index].userInfo.lastName}",
                  style: const TextStyle(fontSize: 20)));
        });
  }
}
