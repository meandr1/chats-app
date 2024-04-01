import 'package:chats/feature/auth/screens/email_auth_screen.dart';
import 'package:chats/feature/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetLandingPage extends StatelessWidget {
  const GetLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData && snapshot.data!.emailVerified) {
          return HomeScreen();
        } else {
          return EmailAuthScreen();
        }
      },
    );
  }
}
