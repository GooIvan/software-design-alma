import 'package:get_it/get_it.dart';

import '../../feature/categories/core/categories_injection.dart';
import '../../feature/home/core/home_injection.dart';
import '../../feature/login/core/login_injection.dart';
import '../../feature/orders/index/core/orders_injection.dart';
import '../../feature/orders/show/core/order_injection.dart';
import '../../feature/products/index/core/products_injection.dart';
import '../../feature/products/show/core/product_injection.dart';
import '../../feature/profile/core/profile_injection.dart';
import '../../feature/register/core/register_injection.dart';

final sl = GetIt.instance;

void init() {
  //* Se inicializa el módulo de Home
  initHomeModule();

  //* Se inicializa el módulo de Profile
  initProfileModule();

  //* Se inicializa el módulo de Register
  initRegisterModule();

  //* Se inicializa el módulo de Login
  initLoginModule();

  //* Se inicializa el módulo de Categories
  initCategoriesModule();

  //* Se inicializa el módulo de Products
  initProductsModule();
  initProductModule();

  //* Se inicializa el módulo de Orders
  initOrdersModule();
  initOrderModule();
}
