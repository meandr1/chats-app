part of 'user_info_cubit.dart';

enum UserInfoStatus {
  initial,
  userLoaded,
  error,
  submitting,
  permissionNotGranted,
  updated
}

class UserInfoState extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final FirebaseUser? currentUser;
  final UserInfoStatus status;
  const UserInfoState({
    this.currentUser,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [currentUser, status, email, phoneNumber, firstName, lastName];

  factory UserInfoState.initial() {
    return const UserInfoState(status: UserInfoStatus.initial);
  }

  UserInfoState copyWith(
      {UserInfoStatus? status,
      FirebaseUser? currentUser,
      String? email,
      String? phoneNumber,
      String? firstName,
      String? lastName}) {
    return UserInfoState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
