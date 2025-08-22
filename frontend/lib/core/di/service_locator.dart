import 'package:get_it/get_it.dart';

import '../../feature/categories/core/categories_injection.dart';
import '../../feature/home/core/home_injection.dart';

final sl = GetIt.instance;

void init() {
  //* Se inicializa el módulo de Home
  initHomeModule();

  //* Se inicializa el módulo de Categories
  initCategoriesModule();
}
