import '../../../core/di/service_locator.dart';
import '../data/bloc/category/category_bloc.dart';
import '../data/bloc/product/product_bloc.dart';
import '../data/repositories/home_repository.dart';

void initHomeModule() {
  // Registro del HomeRepository
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository());

  // Registro del ProductBloc - cambiar a factory para crear instancias nuevas
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(sl<HomeRepository>()),
  );

  sl.registerFactory<CategoryBloc>(
    () => CategoryBloc(sl<HomeRepository>()),
  );
}
