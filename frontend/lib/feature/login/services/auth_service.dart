import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.get(
      Uri.parse("https://mocki.io/v1/51dfd773-1fd6-4452-9e6b-dc61869f2fb9"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] != null) {
        final user = data['data'];

        await _secureStorage.write(key: 'name', value: user['name']);
        await _secureStorage.write(key: 'email', value: user['email']);
        await _secureStorage.write(key: 'profile_image', value: user['profile_image']);

        await _secureStorage.write(key: 'authToken', value: 'mock_token_123');

        return {
          'name': user['name'],
          'email': user['email'],
          'profile_image': user['profile_image'],
        };
      }
    }

    return null;
  }


  Future<Map<String, String?>> getUserData() async {
    final name = await _secureStorage.read(key: 'name');
    final email = await _secureStorage.read(key: 'email');
    final profileImage = await _secureStorage.read(key: 'profile_image');
    final token = await _secureStorage.read(key: 'authToken');

    return {
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'token': token,
    };
  }


  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'authToken');
    return token != null;
  }


  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }
}
