import '../../../core/di/service_locator.dart';
import '../data/repositories/favorites_repository.dart';

void initFavoritesModule() {
  // Registro del Repository
  sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepository());
  // Ya NO se registra el Bloc como singleton, solo el repositorio
}
