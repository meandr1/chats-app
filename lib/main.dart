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
          final args = state.extra as Map<String, dynamic>;
          context.read<FindUsersCubit>().getUsersList();
          return FindUsersScreen(
            onBackButtonPress: args['onBackButtonPress'],
            onUserTap: args['onUserTap'],
          );
        }),
    GoRoute(
        path: '/ConversationScreen',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ConversationScreen(
            onBackButtonPress: args['onBackButtonPress'],
            companionUID: args['companionUID'],
            companionName: args['companionName'],
            companionPhotoURL: args['companionPhotoURL'],
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
        BlocProvider(create: (context) => FindUsersCubit(FindUsersRepository())),
        BlocProvider(create: (context) => ConversationCubit(ConversationRepository())),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}


// Заметил противоеречи: ты говорил, что лучше все переходы оставлять на гоавном экране, 
// а на другие - передавать. В то же время, если на каждый экран делать по кубиту и 
// стремится делать приложение из отдельных блоков, то эти передачи сильно усложняют и увеличивают 
// степень зависимости блоков кода друг от друга. 
// Как я для себя решил - эта рекомендация касается пределов одного кубита (дочерних мелких экранчиков 
// в прелах одного кубита)


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