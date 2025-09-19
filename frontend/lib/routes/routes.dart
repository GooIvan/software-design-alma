import 'package:flutter/material.dart';
import 'package:design_alma/app/main_scaffold.dart';
import '../feature/cart/presentation/pages/cart_page.dart';

class AppRoute {
  static const String main = '/main';
  static const String cart = '/cart';

  static final Map<String, WidgetBuilder> routes = {
    main: (context) => const MainScaffold(initialIndex: 0),
    cart: (context) => const CartPage(),
  };
}
