import 'package:flutter/material.dart';
import 'package:design_alma/routes/routes.dart';
import 'package:design_alma/screens/logo_intro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'feature/cart/data/bloc/cart_bloc.dart';
import 'global/print_local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();

  await printLocalStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DesignAlma App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.white,
          textTheme: GoogleFonts.quanticoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LogoIntro(),
          ...AppRoute.routes,
        },
      ),
    );
  }
}
