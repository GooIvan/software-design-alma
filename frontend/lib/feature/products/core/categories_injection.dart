import 'package:design_alma/feature/products/data/bloc/product_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../data/repositories/product_repository.dart' show ProductRepository;

void initProductsModule() {
  print('Registering ProductRepository...');
  // Registro del Repository
  sl.registerLazySingleton<ProductRepository>(() => ProductRepository());
  print('ProductRepository registered.');

  print('Registering ProductBloc...');
  // Registro del Bloc
  sl.registerLazySingleton<ProductBloc>(
    () => ProductBloc(sl<ProductRepository>()),
  );
  print('ProductBloc registered.');
}
