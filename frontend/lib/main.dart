import 'package:flutter/material.dart';
import 'package:design_alma/routes/routes.dart';
import 'package:design_alma/screens/logo_intro.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRoute = AppRoute();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DesignAlma App',
      home: const LogoIntro(),
      routes: appRoute.routes,
    );
  }
}
