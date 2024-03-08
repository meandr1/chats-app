import 'package:chats/feature/auth/screens/email_auth_screen.dart';
import 'package:chats/feature/auth/screens/forgot_pass_screen.dart';
import 'package:chats/feature/auth/screens/phone_auth_screen.dart';
import 'package:chats/feature/home_screen.dart';
import 'package:chats/feature/auth/screens/register_screen.dart';
import 'package:chats/feature/auth/screens/send_verify_letter_screen.dart';
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


/* 

к кубиту и репозиторию сделать интерфейсы


На основном экране список чатов, и кнопка "плюс", при нажатии на которую должен появиться новый экран 
где будет список пользователей и строка поиска ввепрху, при вводе в которую будет фильтроваться список.
при нжатии на пользователя открывается чат с ним. в чате можно будет отправлять текст, картинки, видеол, аудио, (фото или видео - выбор или с камеры или с галереи)
сообщения должны выглядеть как в телеге в "баблах"
слева и справа должна быть аватарка пользователя
можно листать историю сообщений, должны быть даты как в телеге
в чатах должны быть количество непрочитанных сообщений в режиме реального времени (пришло сообщ - счетчик увеличился)
подключить пуш-уведомления ()
подключить встроенные покупки (бесплатные три чата, 4й за деньги)


2й экран - координаты пользователей на гугл картх, показывать всех пользователей кто где находится
3й экран - профиль с возможностью менять аватарку


снизу тап-бар на три кнопки: чаты, карта (там аватарки пользователй с координатами), третья - профиль

пуш-уведомления и покупки чуть позже


начать экран со списком пользователей
создать основной экран без чатов, внизу тапбар и кнопка плюс
потом экран со списком пользователей
заставить заполнить данные профиля
при каждом открытии приложения обновлять координаты
использовать интерфейсы для всего

/feature/auth - тут все что касается авторизации - кубиты, репозиторий и т.д.



*/