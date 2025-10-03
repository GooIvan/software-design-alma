import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/api.dart';
import '../../../../../models/order_model.dart';

class OrdersRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Order>> fetchOrders() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final response =
        await http.get(Uri.parse('${Api.baseUrl}/api/orders'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true && responseData['orders'] != null) {
        final List<dynamic> ordersData = responseData['orders'];
        return ordersData.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception(responseData['message'] ?? 'Error al cargar órdenes');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token de autenticación inválido');
    } else {
      throw Exception('Error al cargar órdenes: ${response.statusCode}');
    }
  }
}
