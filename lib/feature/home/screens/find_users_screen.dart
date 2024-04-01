import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/feature/home/screens/widgets/get_users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chats/app_constants.dart' as constants;

class FindUsersScreen extends StatelessWidget {
  final _searchUsersInputController = TextEditingController();

  FindUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(HomeRepository())..getUsersList(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                leading: BackButton(onPressed: () => context.go('/')),
                backgroundColor: constants.appBarColor,
                title: const SizedBox(
                  height: 80,
                  child: MainLogo(),
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SearchUsersTextInput(
                        controller: _searchUsersInputController,
                        labelText: 'Filter:',
                        onChanged: (pattern) =>
                            context.read<HomeCubit>().filterUsers(pattern)),
                  ),
                  Expanded(
                      child: state.status == HomeStatus.initial
                          ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator())
                          : state.status == HomeStatus.success
                              ? UsersList(
                                      users: state.filteredUsers, onTap: (_) {})
                              : const Icon(Icons.error)),
                ],
              ));
        },
      ),
    );
  }
}

class SearchUsersTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String) onChanged;
  const SearchUsersTextInput(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: constants.textFormFieldColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const Icon(Icons.person)),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
