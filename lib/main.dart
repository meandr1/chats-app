import 'package:chats/screens/auth/email_auth_screen.dart';
import 'package:chats/screens/forgot_password/forgot_pass_screen.dart';
import 'package:chats/screens/home_screen.dart';
import 'package:chats/screens/register_screen/register_screen.dart';
import 'package:chats/screens/verify_email_screen/send_verify_letter_screen.dart';
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
        GoRoute(
      path: '/ForgotPassScreen',
      builder: (context, state) => ForgotPassScreen(),
    ),
            GoRoute(
      path: '/RegisterScreen',
      builder: (context, state) => RegisterScreen(),
    ),
     GoRoute(
      path: '/SendVerifyLetterScreen',
      builder: (context, state) => SendVerifyLetterScreen(),
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

/* Вопросы:
1. Валидация форм при помощи кубита (мы можем изменить стейт, но это не вызовет метод формы validate(), 
а если передавать из стейта текст ошибки, в поле errorMessage: то сразу при загрузке поля крсные потому что пустые)
2. Как в кубите регистрации перенести трай-кэч в репозиторий но при этом по человечески отслеживать ошибку email in use?


*/

// сделать вход используя cubit и go_router 
// вход должен быть по почте, гугл, фейсбук, телефон
// добавить страницу забыли пароль


// сделать основную страницу входа с аутентификацией через емаил (самому нарисовать)
// и к ней как альтернативу добавить внизу остальные кнопочки аутентификации
// для фейсбуксбук и гугл отдельные экраны создавать не нужно, 
// а для телефона нужно и еще экран для ввода проверочного кода