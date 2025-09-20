import 'package:design_alma/feature/profile/data/bloc/profile_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../data/bloc/profile_event.dart';
import '../data/repositories/profile_repository.dart';

void initProfileModule() {
  // Registro del Repository
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository());

  // Registro del Bloc: se crea uno nuevo cada vez
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(sl<ProfileRepository>())..add(LoadProfile()),
  );
}
