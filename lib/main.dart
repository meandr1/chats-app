import 'package:chats/screens/auth/email_auth_screen.dart';
import 'package:chats/screens/auth/forgot_pass_screen.dart';
import 'package:chats/screens/auth/phone_auth_screen.dart';
import 'package:chats/screens/home_screen.dart';
import 'package:chats/screens/auth/register_screen.dart';
import 'package:chats/screens/auth/send_verify_letter_screen.dart';
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
      path: '/SendVerifyLetterScreen/:email',
      name: 'SendVerifyLetterScreen',
      builder: (context, state) =>
          SendVerifyLetterScreen(email: state.pathParameters['email'] ?? ''),
    ),
    GoRoute(
      path: '/PhoneAuthScreen',
      builder: (context, state) => PhoneAuthScreen(),
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


/* Проблемы:

1. Объединение аккаунтов с одинаковыми почтами, но прошедшими аутунтификацию через разные провайдеры
2. signInWithGoogle()  - мерцание экрана после успешного входа пользователя

*/



/* Вопросы:

1. Валидация форм при помощи кубита (мы можем изменить стейт, но это не вызовет метод формы validate(), 
а если передавать из стейта текст ошибки, в поле errorMessage: то сразу при загрузке поля крсные потому что пустые)
я использовал autovalidateMode: AutovalidateMode.onUserInteraction, и validator. правильно ли?
2. Как в кубите регистрации перенести трай-кэч в репозиторий но при этом по человечески отслеживать ошибку email in use? 
(если try/catch обрабатывать в репозитории, то вернить можно или user или null, а текст ошибки нельзя)
3. Объясни плиз как работает блок провайдер и метод emit()

*/