import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/register_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository repository;

  RegisterBloc({required this.repository}) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      final user = await repository.register(
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        name: event.name,
        lastName: event.lastName,
        city: event.city,
        phone: event.phone,
        address: event.address,
      );

      emit(state.copyWith(status: RegisterStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
