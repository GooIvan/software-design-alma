import 'package:equatable/equatable.dart';

import '../../../../models/user_model.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final User? user;
  final String? errorMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.user,
    this.errorMessage,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
