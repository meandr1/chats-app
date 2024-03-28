import 'package:chats/feature/auth/screens/email_auth_screen.dart';
import 'package:chats/feature/auth/screens/forgot_pass_screen.dart';
import 'package:chats/feature/auth/screens/phone_auth_screen.dart';
import 'package:chats/feature/home/screens/widgets/get_landing_page.dart';
import 'package:chats/feature/home/screens/home_screen.dart';
import 'package:chats/feature/auth/screens/register_screen.dart';
import 'package:chats/feature/auth/screens/send_verify_letter_screen.dart';
import 'package:chats/feature/home/screens/find_users_screen.dart';
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
  initialLocation: '/GetLandingPage',
  routes: [
    GoRoute(
      path: '/GetLandingPage',
      builder: (context, state) => const GetLandingPage(),
    ),
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
    GoRoute(
      path: '/SelectUsersScreen',
      builder: (context, state) => FindUsersScreen(),
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


/* TODO:

На основном экране список чатов, и кнопка "плюс", при нажатии на которую должен появиться новый экран 
где будет список пользователей и строка поиска верху, при вводе в которую будет фильтроваться список.
при нажатии на пользователя открывается чат с ним. в чате можно будет отправлять текст, картинки, видео, аудио, (фото или видео - выбор или с камеры или с галереи)
сообщения должны выглядеть как в телеге в "баблах"
слева и справа должна быть аватарка пользователя
можно листать историю сообщений, должны быть даты как в телеге
в чатах должны быть количество непрочитанных сообщений в режиме реального времени (пришло сообщ - счетчик увеличился)


снизу тап-бар на три кнопки: чаты, карта, профиль:
2й экран - карта: показывать аватарки всех пользователей кто где находится на гугл картах 
3й экран - профиль с возможностью менять аватарку

подключить пуш-уведомления ()
подключить встроенные покупки (бесплатные три чата, 4й за деньги)


начать с экрана со списком пользователей
создать основной экран без чатов, внизу тапбар и кнопка плюс
потом экран со списком пользователей
заставить заполнить данные профиля
при каждом открытии приложения обновлять координаты
использовать интерфейсы для всего

*/


/*

{
  // похоже пришло время придумывать структуру базы данных.))
  // Я читал документацию по этой теме и там очень не рекомендуют использовать большую степень вложенности
  // потому что при загрузке любого узла автоматически загружаются все дочерние, что приводит к увеличению времении
  // отклика и отправки избыточных данных. Рекомендуется максимально "плоская" структура.
  // В связи с этим я предлагаю такой вариант:

  // В этом отдельном узле будет храниться информация о пользователе,
  // а так же его последние сообщения для основного экрана

  // Весь узел будет назван уникальным ID пользователя (либо его можно разделить на два узла (отдельно инфо о пользователе, отдельно список бесед))
  "uid": {
    // тут храним инфо о пользователе
    "userInfo": {
      "firstName": "Oleg",
      "lastName": "Romanov",
      "email": "flash@gmail.com",
      "photoURL": "path_to_stored_photo",
    },
    // тут список собеседников с информацией только о последнем сообщении
    "conversations": {
      "uid": {
        "name": "John",
        "lastMessage": "Хай, чувак, когда бабки вернешь???",
        "timestamp": 1459361875666
        "unreadMessages": 5
      }
      "uid": { ... },
      ...
    },
  },

  // в таком виде предлагаю хранить диалоги. название узла состоит из двух ID разделенных подчеркиванеим
  // сначала айди владельца профиля, потом айди с кем диалог
  "uid1_uid2": {
    "messages": {
      "message1": {
        "isIAmSender": false,
        "message": "Так что там на счет бабок??",
        "isRead": false,
        "timestamp": 1459361875666
      },
      "message2": { ... },
      "message3": { ... },
      ...
    },
  },
    "uid1_uid3": { ... },
    "uid1_uid4": { ... },
    ...

  // Таким образом, когда пользователь открывает конкретный диалог - мы грузим только его, и ничего лишнего
  // причем получать ответ от базы желательно с пагинацией начиная с конца. Благодаря этому мы получим ответ 
  // от базы в одну страничку нужных нам нескольких экранов сообщений
}

*/