part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  const UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object> get props => [message];
}
