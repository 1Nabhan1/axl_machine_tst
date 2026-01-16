import '../../data/models/user_model.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final UserModel user;
  final bool isDarkMode;
  final double profileCompletion;

  AccountLoaded({
    required this.user,
    required this.isDarkMode,
    required this.profileCompletion,
  });
}

class AccountLoggedOut extends AccountState {}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}
