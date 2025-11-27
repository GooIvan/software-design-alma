import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../global/api.dart';
import '../../../../../../models/user_model.dart';

class UsersRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? prefs.getString('token');
  }

  Future<List<User>> fetchUsers() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${Api.baseUrl}/api/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(
        'Error al cargar los usuarios: ${response.statusCode} - ${response.reasonPhrase}\n${response.body}',
      );
    }
  }
}
