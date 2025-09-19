import '../../../core/di/service_locator.dart';
import '../data/bloc/register_bloc.dart';
import '../data/repositories/register_repository.dart';

void initRegisterModule() {
  // Registro del Repository
  sl.registerLazySingleton<RegisterRepository>(() => RegisterRepository());

  // Registro del Bloc
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(repository: sl<RegisterRepository>()),
  );
}
