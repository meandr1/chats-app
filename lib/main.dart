import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/feature/auth/repository/auth_repository.dart';
import 'package:chats/feature/auth/screens/email_auth_screen.dart';
import 'package:chats/feature/auth/screens/forgot_pass_screen.dart';
import 'package:chats/feature/auth/screens/phone_auth_screen.dart';
import 'package:chats/feature/home/cubits/chats/chats_cubit.dart';
import 'package:chats/feature/home/cubits/conversation/conversation_cubit.dart';
import 'package:chats/feature/home/cubits/find_users/find_users_cubit.dart';
import 'package:chats/feature/home/cubits/home/home_cubit.dart';
import 'package:chats/feature/home/cubits/user_info/user_info_cubit.dart';
import 'package:chats/feature/home/repository/chats_repository.dart';
import 'package:chats/feature/home/repository/conversation_repository.dart';
import 'package:chats/feature/home/repository/find_users_repository.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/feature/home/repository/user_info_repository.dart';
import 'package:chats/feature/home/screens/conversation_screen.dart';
import 'package:chats/feature/home/screens/widgets/get_landing_page.dart';
import 'package:chats/feature/home/screens/home_screen.dart';
import 'package:chats/feature/auth/screens/register_screen.dart';
import 'package:chats/feature/auth/screens/send_verify_letter_screen.dart';
import 'package:chats/feature/home/screens/find_users_screen.dart';
import 'package:chats/models/screens_args_transfer_objects.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        builder: (context, state) {
          context.read<HomeCubit>().getCurrentUserInfo();
          return HomeScreen();
        }),
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
        path: '/FindUsersScreen',
        builder: (context, state) {
          context.read<FindUsersCubit>().getUsersList();
          return FindUsersScreen();
        }),
    GoRoute(
        path: '/ConversationScreen',
        builder: (context, state) {
          final args = state.extra as ChatsScreenArgsTransferObject;
          return ConversationScreen(
            companionUID: args.companionUID,
            companionName: args.companionName,
            companionPhotoURL: args.companionPhotoURL,
          );
        }),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(AuthRepository())),
        BlocProvider(create: (context) => HomeCubit(HomeRepository())),
        BlocProvider(create: (context) => UserInfoCubit(UserInfoRepository())),
        BlocProvider(create: (context) => ChatsCubit(ChatsRepository())),
        BlocProvider(
            create: (context) => FindUsersCubit(FindUsersRepository())),
        BlocProvider(
            create: (context) => ConversationCubit(ConversationRepository())),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}




/*

free figma chat design - загуглить и переделать дизайн


в чате можно отправлять текст, картинки, видео, аудио, (фото или видео - выбор или с камеры или с галереи)
сообщения должны выглядеть как в телеге в "баблах"
слева и справа должна быть аватарка пользователя
можно листать историю сообщений, должны быть даты как в телеге
в чатах должны быть количество непрочитанных сообщений в режиме реального времени (пришло сообщ - счетчик увеличился)


снизу тап-бар на три кнопки: чаты, карта, профиль:
1й экран - список чатов
2й экран - карта: показывать аватарки всех пользователей кто где находится на гугл картах 
при каждом открытии приложения обновлять координаты
3й экран - профиль с возможностью менять аватарку

использовать интерфейсы для всего

подключить пуш-уведомления ()
подключить встроенные покупки (бесплатные три чата, 4й за деньги)


*/



/*


+ скорее всего быстрее и меньше нагрузка на базу чем когда все сообщения в куче
 _db.collection('conversationID').orderBy('timestamp',descending: true).limit(1); - такой запрос по идее должен 
 загрузить только одно послендее сообщение

У каждого пользователя:
{
"conversations" : [
                  "conversationID1": companionID1
                  "conversationID2": companionID2
                  "conversationID...N": companionID...N
                ]
},

для каждого чата создаем отдельную коллекцию в базе:
    "conversationID1" : {
      // возможно тут можно использовать массив, но по-моему чтоб получить 
      // хоть одну запись из массива нужно получить весь массив
      "message1ID" : {
        "timestamp" : 12344556,
        "message" : "hello, how are you?",
        "sender" : 1231231,
        "status" : "delivered"
      },
      "message2ID" : {
        "timestamp" : 2434556,
        "message" : "ok",
        "sender" : 1231231,
        "status" : "read"
      },
    }
}


*/