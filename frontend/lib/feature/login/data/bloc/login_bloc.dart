import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/login_repository.dart';
import '../../../../../models/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await repository.login(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess(user));
    } catch (e) {
      print("Error en login: $e");
      emit(LoginFailure(e.toString()));
    }
  }
}
