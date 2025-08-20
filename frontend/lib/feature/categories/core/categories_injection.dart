import '../../../core/di/service_locator.dart';
import '../data/bloc/category_bloc.dart';
import '../data/repositories/categories_repository.dart';

void initCategoriesModule() {
  // Registro del Repository
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepository());

  // Registro del Bloc
  sl.registerLazySingleton<CategoryBloc>(
    () => CategoryBloc(sl<CategoryRepository>())..add(LoadCategories()),
  );
}
