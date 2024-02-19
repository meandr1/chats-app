import 'package:chats/screens/auth/email_auth_screen.dart';
import 'package:chats/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

final _router = GoRouter(
  initialLocation: '/EmailAuthScreen',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/EmailAuthScreen',
      builder: (context, state) => EmailAuthScreen(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}


// сделать вход используя cubit и go_router 
// вход должен быть по почте, гугл, фейсбук, телефон
// добавить страницу забыли пароль


// сделать основную страницу входа с аутентификацией через емаил (самому нарисовать)
// и к ней как альтернативу добавить внизу остальные кнопочки аутентификации
// для фейсбуксбук и гугл отдельные экраны создавать не нужно, 
// а для телефона нужно и еще экран для ввода проверочного кода