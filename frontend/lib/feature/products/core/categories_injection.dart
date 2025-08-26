import 'package:design_alma/feature/products/data/bloc/product_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../data/repositories/product_repository.dart' show ProductRepository;

void initProductsModule() {
  // Registro del Repository
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository());

  // Registro del Bloc
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(sl<ProductRepository>()),
  );
}
