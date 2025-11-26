import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  // URL de tu backend (cambia esto según tu configuración)
  static const String backendUrl = 'http://10.0.2.2:3000'; // Para emulador Android
  // static const String backendUrl = 'http://localhost:3000'; // Para iOS simulator
  // static const String backendUrl = 'https://designalma.loca.lt'; // Para producción/testing

  /// Inicia sesión con Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Inicia el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return null;
      }

      // Obtiene los detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Obtiene el access token
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('No se pudo obtener el token de Google');
      }

      // Envía el token al backend de Rails para autenticación
      final response = await http.post(
        Uri.parse('$backendUrl/users/auth/google_oauth2/callback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'access_token': accessToken,
          'id_token': idToken,
        }),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return {
          'success': true,
          'user': userData,
          'email': googleUser.email,
          'displayName': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
        };
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      rethrow;
    }
  }

  /// Cierra la sesión de Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print('Error al cerrar sesión de Google: $error');
      rethrow;
    }
  }

  /// Verifica si el usuario ya está autenticado
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Obtiene el usuario actual de Google
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Inicia sesión silenciosamente (si ya hay una sesión previa)
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (error) {
      print('Error al iniciar sesión silenciosamente: $error');
      return null;
    }
  }
}
