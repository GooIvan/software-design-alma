import 'package:flutter/material.dart';
import 'package:design_alma/routes/routes.dart';
import 'package:design_alma/screens/logo_intro.dart'; // 👈 Tu animación Lottie

void main() {
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
      home: const LogoIntro(), // 👈 Se muestra enseguida al abrir
      routes: appRoute.routes,
    );
  }
}
