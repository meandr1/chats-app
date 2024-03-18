import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/chats_screen.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chats/app_constants.dart' as constants;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) =>
          HomeCubit(HomeRepository()),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // if (state.status == AuthStatus.initial) {
          //   context.go('/EmailAuthScreen');
          // }
        },
        builder: (context, state) {
          return MaterialApp(
            home: DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: constants.appBarColor,
                  title: const SizedBox(
                    height: 80,
                    child: MainLogo(),
                  ),
                ),
                bottomNavigationBar: Container(
                  color: constants.bottomNavigationBarColor,
                  child: const TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.all(5.0),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(icon: Icon(size: 35, Icons.messenger_outlined)),
                        Tab(icon: Icon(size: 35, Icons.location_on)),
                        Tab(icon: Icon(size: 35, Icons.person)),
                      ]),
                ),
                body: TabBarView(
                  children: [
                    ChatsWidget(onPressed: () {
                      context.go('/SelectUsersScreen');
                    }
                        // () => context.read<AuthCubit>().signOut()
                        ),
                    const Icon(Icons.location_on),
                    const Icon(Icons.person),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
