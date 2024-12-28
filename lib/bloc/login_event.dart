part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEventReset extends LoginEvent {
  LoginEventReset();
  @override
  List<Object> get props => [];
}

class LoginEventResetPassword extends LoginEvent {
  final String email;
  LoginEventResetPassword({required this.email});
  @override
  List<Object> get props => [email];
}

class LoginEventSubmit extends LoginEvent {
  final String username;
  final String password;

  LoginEventSubmit({required this.username, required this.password});
  @override
  List<Object> get props => [username, password];
}
