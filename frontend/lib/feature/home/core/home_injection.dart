import 'package:get_it/get_it.dart';

import '../../../core/di/service_locator.dart';
import '../data/bloc/category/category_bloc.dart';
import '../data/bloc/product/product_bloc.dart';
import '../data/repositories/home_repository.dart';

void initHomeModule() {
  // Registro del HomeRepository
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository());

  // Registro del ProductBloc
  sl.registerLazySingleton<ProductBloc>(
    () => ProductBloc(sl<HomeRepository>())..add(LoadProducts()),
  );

  sl.registerLazySingleton<CategoryBloc>(
    () => CategoryBloc(sl<HomeRepository>())..add(LoadCategories()),
  );
}
