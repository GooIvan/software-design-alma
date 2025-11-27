import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../models/user_model.dart';
import '../repository/users_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository repository;
  UsersBloc(this.repository) : super(UsersInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await repository.fetchUsers();
        emit(UsersLoaded(users));
      } catch (e) {
        print('Error al cargar los users: $e');
        emit(const UsersError("Error al cargar los users"));
      }
    });

    on<RefreshUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await repository.fetchUsers();
        emit(UsersLoaded(users));
      } catch (e) {
        print('Error al refrescar los users: $e');
        emit(const UsersError("Error al refrescar los users"));
      }
    });
  }
}
