part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class Login extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;
  Login(this.password, this.username, this.rememberMe);
}

class LogoutEvent extends AuthEvent {}

class GetLocalUser extends AuthEvent {}
