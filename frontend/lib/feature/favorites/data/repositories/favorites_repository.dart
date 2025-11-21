import 'dart:convert';
import 'package:http/http.dart' as http;
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
  Future<List<Favorite>> fetchFavorites() async {
    final response =
        await http.get(Uri.parse('${Api.baseUrl}/api/favorites'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Favorite.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      // Usuario no autenticado
      throw UnauthorizedException(
          'Necesitas iniciar sesión o registrarte para continuar.');
    } else {
      throw Exception(
        'Error al cargar productos: ${response.statusCode} - ${response.reasonPhrase}\n${response.body}',
      );
    }
  }
}
