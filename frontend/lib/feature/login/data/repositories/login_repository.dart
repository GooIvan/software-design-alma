import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../global/api.dart';
import '../../../../models/user_model.dart';

class LoginRepository {
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${Api.baseUrl}/es/api/auth/sign_in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': {
          'email': email,
          'password': password,
        }
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print(data);

      // Guardar token y usuario en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (data['token'] != null) {
        await prefs.setString('token', data['token']);
      }
      if (data['user'] != null) {
        await prefs.setString('user_data', jsonEncode(data['user']));
      }

      return User.fromJson(data['user']);
    } else {
      print('Error al iniciar sesión: ${response.body}');
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  /// Método para obtener el usuario guardado localmente
  Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  /// Método para obtener el token guardado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Método para eliminar la info de usuario y token (logout)
  Future<void> clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_data');
  }
}
