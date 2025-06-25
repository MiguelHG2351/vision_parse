part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthEmailLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthEmailLoginEvent({
    required this.email,
    required this.password,
  });
}

class AuthCheckSession extends AuthEvent {
  AuthCheckSession();
}
