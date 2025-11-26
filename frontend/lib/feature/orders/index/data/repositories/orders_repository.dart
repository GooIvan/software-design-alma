import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/api.dart';
import '../../../../../models/order_model.dart';

class OrdersRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? prefs.getString('token');
  }

  Future<List<Order>> fetchOrders() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final url = Uri.parse('${Api.baseUrl}/api/orders');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
        // API Rails estándar: { status: "success", data: [...] }
        if (body['data'] is List) {
          return (body['data'] as List)
              .map((json) => Order.fromJson(json))
              .toList();
        }

        // Formato alterno que tú mismo podrías haber usado: { success: true, orders: [...] }
        if (body['success'] == true && body['orders'] is List) {
          return (body['orders'] as List)
              .map((json) => Order.fromJson(json))
              .toList();
        }

        throw Exception('Formato de respuesta inesperado');

      case 401:
        throw Exception('Token de autenticación inválido');

      default:
        throw Exception(
            'Error al cargar órdenes: ${response.statusCode} — ${body['message'] ?? ''}');
    }
  }
}
