import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../routes/routes.dart';

class LogoIntro extends StatefulWidget {
  const LogoIntro({super.key});

  @override
  State<LogoIntro> createState() => _LogoIntroState();
}

class _LogoIntroState extends State<LogoIntro> with TickerProviderStateMixin {
  double _opacity = 1.0;
  bool _hasStarted = false;

  void _startFadeAndRedirect() async {
    if (_hasStarted) return;
    _hasStarted = true;

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    setState(() => _opacity = 0.0);

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(AppRoute.main);
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
                _startFadeAndRedirect();
              },
            ),
          ),
        ),
      ),
    );
  }
}
