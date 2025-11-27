import '../../../../../core/di/service_locator.dart';
import '../data/bloc/users_bloc.dart';
import '../data/repository/users_repository.dart';

void initUsersModule() {
  // Registro del Repository
  sl.registerLazySingleton<UsersRepository>(() => UsersRepository());

  // Registro del Bloc
  sl.registerLazySingleton<UsersBloc>(() => UsersBloc(sl<UsersRepository>()));
}
