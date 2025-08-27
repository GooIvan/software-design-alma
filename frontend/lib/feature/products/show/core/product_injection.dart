import '../../../../core/di/service_locator.dart';
import '../data/bloc/product_bloc.dart';
import '../data/repositories/product_repository.dart' show ProductRepository;

void initProductModule() {
  // Registro del Repository
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository());

  // Registro del Bloc
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(sl<ProductRepository>()),
  );
}
