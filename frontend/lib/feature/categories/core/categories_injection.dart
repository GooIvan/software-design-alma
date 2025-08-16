import 'package:get_it/get_it.dart';

import '../data/bloc/category_bloc.dart';
import '../data/repositories/categories_repository.dart';

final sl = GetIt.instance;

void initCategoriesModule() {
  // Registro del Repository
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepository());

  // Registro del Bloc
  sl.registerLazySingleton<CategoryBloc>(
    () => CategoryBloc(sl<CategoryRepository>())..add(LoadCategories()),
  );
}
