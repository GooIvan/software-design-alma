import '../../../core/di/service_locator.dart';
import '../data/bloc/favorites_bloc.dart';
import '../data/repositories/favorites_repository.dart';

void initFavoritesModule() {
  // Registro del Repository
  sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepository());

  // Registro del Bloc
  sl.registerLazySingleton<FavoritesBloc>(
    () => FavoritesBloc(sl<FavoritesRepository>())..add(LoadFavorites()),
  );
}
