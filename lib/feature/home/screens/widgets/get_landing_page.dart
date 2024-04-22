import 'package:chats/feature/auth/screens/email_auth_screen.dart';
import 'package:chats/feature/home/cubits/home/home_cubit.dart';
import 'package:chats/feature/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetLandingPage extends StatelessWidget {
  const GetLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      context.read<HomeCubit>().getCurrentUserInfo();
      return HomeScreen();
    } else {
      return EmailAuthScreen();
    }
  }
}
