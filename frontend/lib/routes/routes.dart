import 'package:flutter/material.dart';
import 'package:design_alma/app/main_scaffold.dart';
import '../feature/admin/app/admin_main_scaffold.dart';

import '../feature/terms/pages/terms _and_conditions.dart';
import '../feature/cart/presentation/pages/cart_page.dart';

class AppRoute {
  static const String main = '/main';
  static const String admin = '/admin';
  static const String cart = '/cart';
  static const String terms = '/terms';

  static final Map<String, WidgetBuilder> routes = {
    main: (context) => const MainScaffold(initialIndex: 0),
    admin: (context) => const AdminMainScaffold(initialIndex: 0),
    cart: (context) => const CartPage(),
    terms: (context) => const TermsAndConditionsPage(),
  };
}
