import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/api.dart';
import '../../../../../models/order_model.dart';

class OrderRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Order> fetchOrder(int orderId) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await http
        .get(Uri.parse('${Api.baseUrl}/api/orders/$orderId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true && responseData['order'] != null) {
        final Map<String, dynamic> orderData = responseData['order'];
        print('Order data: $orderData');
        return Order.fromJson(orderData);
      } else {
        throw Exception(responseData['message'] ?? 'Error al cargar la orden');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token de autenticación inválido');
    } else if (response.statusCode == 404) {
      throw Exception('Orden no encontrada');
    } else {
      throw Exception('Error al cargar la orden: ${response.statusCode}');
    }
  }
}
