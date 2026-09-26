part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterRequested({required this.name, required this.email, required this.password});
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested({required this.email});
}

class GoogleSignInRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
