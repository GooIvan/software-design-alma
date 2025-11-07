import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/api.dart';
import '../../../../../models/order_model.dart';
import '../../../../../models/cart_item_model.dart';

class CreateOrderRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  /// Convierte los items del carrito al formato requerido por la API
  List<Map<String, dynamic>> _convertCartItemsToApiFormat(
      List<CartItem> cartItems) {
    final converted = cartItems
        .map((item) => {
              'product_id': item.productId,
              'quantity': item.quantity,
              'size': item.size,
            })
        .toList();

    return converted;
  }

  /// Crea una orden desde una lista de CartItem
  Future<Order> createOrderFromCart(List<CartItem> cartItems,
      {String? discountCode}) async {
    final items = _convertCartItemsToApiFormat(cartItems);
    return await createOrder(items, discountCode: discountCode);
  }

  /// Crea una orden desde una lista de mapas (formato API directo)
  Future<Order> createOrder(List<Map<String, dynamic>> items,
      {String? discountCode}) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final requestBody = {
      'items': items,
      if (discountCode != null) 'discount_code': discountCode,
    };

    final response = await http.post(
      Uri.parse('${Api.baseUrl}/api/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true && responseData['order'] != null) {
        final Map<String, dynamic> orderData = responseData['order'];
        return Order.fromJson(orderData);
      } else {
        throw Exception(responseData['message'] ?? 'Error al crear la orden');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token de autenticación inválido');
    } else if (response.statusCode == 422) {
      final Map<String, dynamic> errorData = jsonDecode(response.body);

      // Si hay errores específicos, procesarlos para mostrar mensaje amigable
      if (errorData['errors'] != null && errorData['errors'] is List) {
        final List<String> errors = List<String>.from(errorData['errors']);

        // Verificar si es un error de stock
        final stockErrors = errors
            .where((error) => error.contains('no tiene stock suficiente'))
            .toList();

        if (stockErrors.isNotEmpty) {
          throw Exception(
              'Algunos productos no tienen stock disponible. Por favor, revisa tu carrito.');
        } else {
          throw Exception(errors.join('\n'));
        }
      } else {
        throw Exception(errorData['message'] ?? 'Datos de orden inválidos');
      }
    } else {
      throw Exception('Error al crear la orden: ${response.statusCode}');
    }
  }
}
