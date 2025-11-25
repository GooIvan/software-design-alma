import 'dart:convert';
import 'package:design_alma/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../global/api.dart';

class ProfileRepository {
  Future<User?> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // obtener token (priorizar auth_token de Google login)
    final token = prefs.getString('auth_token') ?? prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Usuario no autenticado');
    }

    // Hacer petición al backend
    // El token ya incluye "Bearer-" así que no agregamos "Bearer " adicional
    final authHeader = token.startsWith('Bearer') ? token : 'Bearer $token';
    
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/api/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authHeader,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Verificar si la respuesta tiene el formato esperado del backend
      if (data['success'] == true && data['user'] != null) {
        final userData = data['user'];

        // Guardar los datos del usuario
        await prefs.setString('user_data', jsonEncode(userData));
        return User.fromJson(userData);
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } else if (response.statusCode == 401) {
      // Token inválido o expirado
      await _clearUserData(prefs);
      throw const TokenExpiredException('Token inválido o expirado');
    } else {
      throw Exception('Error al cargar perfil: ${response.body}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('${Api.baseUrl}/api/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode != 200) {
          throw Exception('Error al cerrar sesión: ${response.body}');
        }
      } catch (e) {
        throw Exception('Error al cerrar sesión: $e');
      }
    }

    await _clearUserData(prefs);
  }

  Future<User?> updateProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Usuario no autenticado');
    }

    try {
      // Hacer petición PUT al backend
      final response = await http.put(
        Uri.parse('${Api.baseUrl}/api/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': user.name,
          'last_name': user.lastName,
          'phone': user.phone,
          'address': user.address,
          'city': user.city,
        }),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['user'] != null) {
          final userData = data['user'];
          
          // Actualizar los datos del usuario en SharedPreferences
          await prefs.setString('user_data', jsonEncode(userData));
          return User.fromJson(userData);
        } else {
          throw Exception('Formato de respuesta inválido');
        }
      } else if (response.statusCode == 401) {
        await _clearUserData(prefs);
        throw const TokenExpiredException('Token inválido o expirado');
      } else {
        throw Exception('Error al actualizar perfil: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error en updateProfile: $e');
      rethrow;
    }
  }

  Future<void> _clearUserData(SharedPreferences prefs) async {
    await prefs.remove('token');
    await prefs.remove('user_data');
  }
}

// Custom exception para tokens expirados
class TokenExpiredException implements Exception {
  final String message;
  const TokenExpiredException(this.message);

  @override
  String toString() => message;
}
