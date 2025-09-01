import 'package:design_alma/feature/products/index/data/bloc/products_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../data/repositories/product_repository.dart' show ProductsRepository;

void initProductsModule() {
  // Registro del Repository
  sl.registerLazySingleton<ProductsRepository>(() => ProductsRepository());

  // Registro del Bloc
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(sl<ProductsRepository>()),
  );
}
