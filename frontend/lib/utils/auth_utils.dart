import 'package:shared_preferences/shared_preferences.dart';

/// Utilidad para saber si el usuario está logueado (token presente)
Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? prefs.getString('token');
  return token != null && token.isNotEmpty;
}
