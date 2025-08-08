import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_alma/routes/routes.dart';
import 'package:design_alma/screens/logo_intro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Service Locator para optimizar rendimiento
  sl.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.cartBloc,
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorSchemeSeed: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        title: 'DesignAlma App',
        initialRoute: '/',
        routes: {
          '/': (context) => const LogoIntro(),
          ...AppRoute.routes,
        },
      ),
    );
  }
}
