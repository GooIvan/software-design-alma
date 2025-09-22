part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String name;
  final String lastName;
  final String city;
  final String phone;
  final String address;

  RegisterSubmitted({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.name,
    required this.lastName,
    required this.city,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirmation,
        name,
        lastName,
        city,
        phone,
        address
      ];
}
