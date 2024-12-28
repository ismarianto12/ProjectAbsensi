part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSucces extends LoginState {
  final String message;

  LoginSucces({required this.message});

  @override
  List<Object> get props => [message];
}

class LoginFail extends LoginState {
  final String message;
  LoginFail({required this.message});
  @override
  List<Object> get props => [message];
}


class ResetSucces extends LoginState {
  final String message;

  ResetSucces({required this.message});

  @override
  List<Object> get props => [message];
}

class ResetFail extends LoginState {
  final String message;
  ResetFail({required this.message});
  @override
  List<Object> get props => [message];
}
