import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;

  LoginRequested({
    required this.username,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [username, password, rememberMe];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String fullName;
  final String password;
  final String dob;
  final String profileImagePath;

  RegisterRequested({
    required this.username,
    required this.fullName,
    required this.password,
    required this.dob,
    required this.profileImagePath,
  });
}

class LogoutRequested extends AuthEvent {}
