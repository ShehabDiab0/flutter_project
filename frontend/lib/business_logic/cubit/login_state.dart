part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  final String name;

  LoginSuccess({required this.token, required this.name});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
