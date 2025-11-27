import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../global/api.dart';
import '../../../../models/favorite_model.dart';

/// Excepción lanzada cuando la API responde 401 Unauthorized
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class FavoritesRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? prefs.getString('token');
  }

  Future<List<Favorite>> fetchFavorites() async {
    final token = await _getToken();

    if (token == null) {
      throw UnauthorizedException('Usuario no autenticado');
    }
    final response =
        await http.get(Uri.parse('${Api.baseUrl}/api/favorites'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Verificar que la respuesta tenga la estructura esperada
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List<dynamic> data = responseData['data'];
        return data.map((json) => Favorite.fromJson(json)).toList();
      } else {
        throw Exception('Respuesta de API inválida: ${response.body}');
      }
    } else if (response.statusCode == 401) {
      // Usuario no autenticado
      throw UnauthorizedException(
          'Necesitas iniciar sesión o registrarte para continuar.');
    } else {
      throw Exception(
        'Error al cargar favoritos: ${response.statusCode} - ${response.reasonPhrase}\n${response.body}',
      );
    }
  }

  Future<Favorite> addFavorite(int productId) async {
    final token = await _getToken();

    if (token == null) {
      throw UnauthorizedException('Usuario no autenticado');
    }

    final response = await http.post(
      Uri.parse('${Api.baseUrl}/api/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': productId,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        return Favorite.fromJson(responseData['data']);
      } else {
        throw Exception('Respuesta de API inválida: ${response.body}');
      }
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(
          'Necesitas iniciar sesión o registrarte para continuar.');
    } else if (response.statusCode == 404) {
      throw Exception('Producto no encontrado');
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final errorMessage = responseData['message'] ?? 'Error desconocido';
      throw Exception('Error al agregar a favoritos: $errorMessage');
    }
  }

  Future<void> removeFavorite(int favoriteId) async {
    final token = await _getToken();

    if (token == null) {
      throw UnauthorizedException('Usuario no autenticado');
    }

    final response = await http.delete(
      Uri.parse('${Api.baseUrl}/api/favorites/$favoriteId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] != 'success') {
        throw Exception(
            'Error al eliminar favorito: ${responseData['message']}');
      }
      // Éxito, no necesitamos retornar nada
    } else if (response.statusCode == 401) {
      throw UnauthorizedException(
          'Necesitas iniciar sesión o registrarte para continuar.');
    } else if (response.statusCode == 404) {
      throw Exception('Favorito no encontrado');
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final errorMessage = responseData['message'] ?? 'Error desconocido';
      throw Exception('Error al eliminar favorito: $errorMessage');
    }
  }
}
