import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEventReset>((event, emit) {
      emit(LoginInitial());
    });
    on<LoginEventSubmit>((event, emit) {
      if (event.username == "admin") {
        emit(LoginSucces(message: "berhasil"));
      } else {
        emit(LoginFail(message: "username dan password salah"));
      }
    });

    on<LoginEventResetPassword>((event, emit) {
      if (event.email == "admin") {
        emit(LoginSucces(message: "berhasil"));
      } else {
        emit(LoginFail(message: "username dan password salah"));
      }
    });
  }
}
