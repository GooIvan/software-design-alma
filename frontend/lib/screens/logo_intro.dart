import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:design_alma/feature/login/screens/login_screen.dart';
import 'package:design_alma/app/main_scaffold.dart';

class LogoIntro extends StatefulWidget {
  const LogoIntro({super.key});

  @override
  State<LogoIntro> createState() => _LogoIntroState();
}

class _LogoIntroState extends State<LogoIntro> with TickerProviderStateMixin {
  double _opacity = 1.0;

  void _startFadeAndRedirect() async {
    await Future.delayed(const Duration(seconds: 3)); // Espera animación
    setState(() => _opacity = 0.0); // Fade out

    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            isLoggedIn ? MainScaffold(initialIndex: 4) : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _opacity,
          child: Transform.scale(
            scale: 1.8,
            child: Lottie.asset(
              'assets/animations/logo_intro.json',
              fit: BoxFit.contain,
              repeat: false,
              onLoaded: (_) {
                _startFadeAndRedirect(); // 👈 Solo inicia después de cargar
              },
            ),
          ),
        ),
      ),
    );
  }
}
