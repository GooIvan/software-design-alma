import 'package:flutter/material.dart';
import 'package:design_alma/app/main_scaffold.dart';
import '../feature/login/screens/Forgot_Password_Screen.dart';
import '../feature/login/screens/Register_Screen.dart';
import 'package:design_alma/feature/login/screens/login_screen.dart';
import '../feature/cart/presentation/pages/cart_page.dart';

class AppRoute {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  static const String main = '/main';
  static const String cart = '/cart';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    register: (context) => const RegisterScreen(),
    main: (context) => const MainScaffold(initialIndex: 0),
    cart: (context) => const CartPage(),
  };
}
