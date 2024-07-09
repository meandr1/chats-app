import 'package:chats/app_constants.dart';
import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/feature/auth/repository/auth_repository.dart';
import 'package:chats/feature/auth/screens/email_auth_screen.dart';
import 'package:chats/feature/auth/screens/forgot_pass_screen.dart';
import 'package:chats/feature/auth/screens/phone_auth_screen.dart';
import 'package:chats/feature/chats/cubit/chats_cubit.dart';
import 'package:chats/feature/conversation/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/cubits/media_cubit/media_cubit.dart';
import 'package:chats/feature/conversation/repository/media_repository.dart';
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
import 'package:chats/hive_boxes.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/message.dart';
import 'package:chats/models/screens_args_transfer_objects.dart';
import 'package:chats/services/cache_service/cache_service.dart';
import 'package:chats/services/files_service/files_service.dart';
import 'package:chats/services/files_service/local_files_service.dart';
import 'package:chats/services/files_service/remote_files_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TimestampAdapter());
  Hive.registerAdapter(ConversationLayoutAdapter());
  Hive.registerAdapter(MessageAdapter());
  filesBox = await Hive.openBox<String>(AppConstants.localFilesCollection);
  conversationLayoutBox = await Hive.openBox<List>(
    AppConstants.localConversationLayoutCollection);
  messageBox = await Hive.openBox<List>(AppConstants.localMessageCollection);
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
          context.read<VoiceRecordingCubit>().checkMicPermission();
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
        BlocProvider(create: (context) => HomeCubit(HomeRepository(FilesService(
              localFilesService: LocalFilesService(),
              remoteFilesService: RemoteFilesService())))),
        BlocProvider(create: (context) => UserInfoCubit(UserInfoRepository(FilesService(
              localFilesService: LocalFilesService(),
              remoteFilesService: RemoteFilesService())))),
        BlocProvider(create: (context) => ChatsCubit(ChatsRepository(CacheService()))),
        BlocProvider(create: (context) => FindUsersCubit(FindUsersRepository())),
        BlocProvider(create: (context) => ConversationCubit(ConversationRepository(CacheService()))),
        BlocProvider(create: (context) => MapCubit(MapRepository(FilesService(
              localFilesService: LocalFilesService(),
              remoteFilesService: RemoteFilesService())))),
        BlocProvider(create: (context) =>VoiceRecordingCubit(VoiceRecordingRepository(FilesService(
              localFilesService: LocalFilesService(),
              remoteFilesService: RemoteFilesService())))),
        BlocProvider(create: (context) => MediaCubit(MediaRepository(FilesService(
              localFilesService: LocalFilesService(),
              remoteFilesService: RemoteFilesService())))),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}
