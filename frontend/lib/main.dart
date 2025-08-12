import 'package:design_alma/feature/cart/data/bloc/cart_bloc.dart';
import 'package:design_alma/feature/categories/data/bloc/categories_bloc.dart';
import 'package:design_alma/feature/categories/data/repositories/categories_repository.dart';
import 'package:design_alma/feature/home/data/bloc/product/product_bloc.dart';
import 'package:design_alma/feature/home/data/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_alma/routes/routes.dart';
import 'package:design_alma/screens/logo_intro.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) =>
              ProductBloc(HomeRepository())..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) =>
              CategoriesBloc(CategoriesRepository())..add(LoadCategories()),
        ),
      ],
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
