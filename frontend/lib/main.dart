import 'package:design_alma/routes/routes.dart';
import 'package:flutter/material.dart';

import 'feature/categories/repositories/category_repository.dart';
import 'feature/best_sellers/ui/best_sellers_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CategoryRepository categoryRepository = CategoryRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRoute = AppRoute();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DesignAlma App',
      initialRoute: AppRoute.home,
      routes: appRoute.routes,
    );
  }
}
