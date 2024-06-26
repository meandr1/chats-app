import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/feature/auth/repository/auth_repository.dart';
import 'package:chats/feature/auth/screens/email_auth_screen.dart';
import 'package:chats/feature/auth/screens/forgot_pass_screen.dart';
import 'package:chats/feature/auth/screens/phone_auth_screen.dart';
import 'package:chats/feature/chats/cubit/chats_cubit.dart';
import 'package:chats/feature/conversation/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/cubits/images_cubit/images_cubit.dart';
import 'package:chats/feature/conversation/repository/images_repository.dart';
import 'package:chats/feature/conversation/repository/voice_recording_repository.dart';
import 'package:chats/feature/conversation/cubits/voice_recording_cubit/voice_recording_cubit.dart';
import 'package:chats/feature/find_users/cubit/find_users_cubit.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/map/cubit/map_cubit.dart';
import 'package:chats/feature/map/repository/map_repository.dart';
import 'package:chats/feature/user_info/cubit/user_info_cubit.dart';
import 'package:chats/feature/chats/repository/chats_repository.dart';
import 'package:chats/feature/conversation/repository/conversation_repository.dart';
import 'package:chats/feature/find_users/repository/find_users_repository.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/feature/user_info/repository/user_info_repository.dart';
import 'package:chats/feature/conversation/screen/conversation_screen.dart';
import 'package:chats/feature/home/screen/widgets/get_landing_page.dart';
import 'package:chats/feature/home/screen/home_screen.dart';
import 'package:chats/feature/auth/screens/register_screen.dart';
import 'package:chats/feature/auth/screens/send_verify_letter_screen.dart';
import 'package:chats/feature/find_users/screen/find_users_screen.dart';
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
          context.read<ConversationCubit>().setState(args: args);
          return ConversationScreen();
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
        BlocProvider(create: (context) => MapCubit(MapRepository())),
        BlocProvider(
            create: (context) =>
                VoiceRecordingCubit(VoiceRecordingRepository())),
        BlocProvider(create: (context) => ImagesCubit(ImagesRepository())),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}

/*
jira - прогр для назначения задач

agile
scram
waterfall
подходы к организации работы команды

slack - переписка
*/


/*

в чате можно отправлять текст, фото, видео, аудио, (фото или видео - выбор или с камеры или с галереи)
после добавления картинок, нужно добавить чтоб при нажатии на фото фидео оно открывалось на весь экран.
сделать локальное хранилище - Hive
если отправляешь ссылку - она отображается с предпросмотром
групповые чаты - название, доавлять людей из списка

подключить пуш-уведомления ()
подключить встроенные покупки (бесплатные три чата, 4й за деньги)

использовать интерфейсы для всего

free figma chat design - загуглить и переделать дизайн

*/