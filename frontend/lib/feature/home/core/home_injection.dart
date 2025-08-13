import 'package:get_it/get_it.dart';

import '../data/bloc/product/product_bloc.dart';
import '../data/repositories/home_repository.dart';

final sl = GetIt.instance;

void initHomeModule() {
  // Registro del HomeRepository
  sl.registerLazySingleton<HomeRepository>(() => HomeRepository());

  // Registro del ProductBloc
  sl.registerLazySingleton<ProductBloc>(
    () => ProductBloc(sl<HomeRepository>())..add(LoadProducts()),
  );
}
