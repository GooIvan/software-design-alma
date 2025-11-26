import '../../../../../core/di/service_locator.dart';
import '../data/bloc/admin_products_bloc.dart';
import '../data/repository/admin_products.dart';

void initAdminProductsModule() {
  // Registro del Repository
  sl.registerLazySingleton<AdminProductsRepository>(
      () => AdminProductsRepository());

  // Registro del Bloc
  sl.registerLazySingleton<AdminProductsBloc>(
    () => AdminProductsBloc(sl<AdminProductsRepository>()),
  );
}
