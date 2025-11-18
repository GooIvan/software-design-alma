import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // URL de tu backend Rails
  static const String baseUrl = 'http://10.0.2.2:3000'; // Para emulador Android
  // static const String baseUrl = 'http://localhost:3000'; // Para iOS simulator
  // static const String baseUrl = 'https://tu-dominio.com'; // Para producción

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    // Usar el Web Client ID como serverClientId
    serverClientId: '354443077313-0fno50ulf9pt68kvb44hsu5fq3t8pnt1.apps.googleusercontent.com',
  );

  // Iniciar sesión con Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return null;
      }

      // Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Enviar el token al backend Rails
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/google'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_token': googleAuth.idToken,
          'access_token': googleAuth.accessToken,
          'email': googleUser.email,
          'name': googleUser.displayName,
          'photo_url': googleUser.photoUrl,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Guardar el token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token'] ?? '');
        await prefs.setString('user_email', googleUser.email);
        await prefs.setString('user_name', googleUser.displayName ?? '');
        
        return {
          'success': true,
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        print('Error del servidor: ${response.statusCode}');
        print('Respuesta: ${response.body}');
        return {
          'success': false,
          'error': 'Error al autenticar con el servidor',
        };
      }
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      return {
        'success': false,
        'error': error.toString(),
      };
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Obtener el token guardado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Obtener información del usuario guardada
  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('user_email'),
      'name': prefs.getString('user_name'),
    };
  }
}
