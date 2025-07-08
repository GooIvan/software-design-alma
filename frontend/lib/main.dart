import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:design_alma/routes/routes.dart';
import 'package:design_alma/app/main_scaffold.dart';
import 'package:design_alma/feature/login/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final appRoute = AppRoute();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DesignAlma App',
      home: isLoggedIn ? MainScaffold(initialIndex: 4) : const LoginScreen(),
      routes: appRoute.routes,
    );
  }
}
