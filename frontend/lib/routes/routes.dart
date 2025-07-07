import 'package:flutter/material.dart';
import 'package:design_alma/app/main_scaffold.dart';
import 'package:design_alma/feature/login/screens/Forgot_Password_Screen.dart';
import 'package:design_alma/feature/login/screens/Register_Screen.dart';
import 'package:design_alma/feature/login/screens/login_screen.dart';

class AppRoute {
  static const String home = '/login';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  static const String perfil = '/perfil';

  final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    register: (context) => const RegisterScreen(),
    perfil: (context) => MainScaffold(initialIndex: 4),
  };
}
