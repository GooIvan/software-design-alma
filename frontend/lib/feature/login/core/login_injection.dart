import '../../../core/di/service_locator.dart';
import '../data/bloc/login_bloc.dart';
import '../data/repositories/login_repository.dart';

void initLoginModule() {
  // Registro del Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepository());

  // Registro del Bloc
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl<LoginRepository>()),
  );
}
