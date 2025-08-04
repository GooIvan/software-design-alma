import 'package:flutter/material.dart';
import 'package:design_alma/routes/routes.dart';
import 'package:design_alma/screens/logo_intro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'authToken');


  final bool isLoggedIn = token != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorSchemeSeed: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      title: 'DesignAlma App',

      initialRoute: AppRoute.main,
      routes: AppRoute.routes,
    );
  }
}
