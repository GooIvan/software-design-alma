import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../global/api.dart';
import '../../../../models/payment_model.dart';

class PaymentRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Procesa un pago con PayU
  Future<PaymentResponse> processPayuPayment({
    required int orderId,
    required CardData cardData,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Usuario no autenticado');
      }

      const url = '${Api.baseUrl}/api/payments/process_payu_payment';

      final requestBody = {
        'order_id': orderId,
        ...cardData.toJson(),
      };

      print('Procesando pago para orden:: $orderId');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        return PaymentResponse.fromJson(responseData);
      } else {
        // Manejar errores HTTP
        try {
          final errorData = jsonDecode(response.body);
          return PaymentResponse(
            success: false,
            message: errorData['message'] ?? 'Error del servidor',
            errorCode: errorData['error_code'],
            payuError: errorData['payu_error'],
          );
        } catch (e) {
          return PaymentResponse(
            success: false,
            message: 'Error del servidor: ${response.statusCode}',
            errorCode: 'HTTP_ERROR',
          );
        }
      }
    } catch (e) {
      print('Error in processPayuPayment: $e');
      return PaymentResponse(
        success: false,
        message: 'Error de conexión: $e',
        errorCode: 'CONNECTION_ERROR',
      );
    }
  }

  /// Consulta el estado de un pago
  Future<PaymentStatusResponse> getPaymentStatus({
    required int orderId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return PaymentStatusResponse(
          success: false,
          message: 'No se pudo obtener el token de autenticación',
        );
      }

      final url =
          '${Api.baseUrl}/api/payments/payment_status?order_id=$orderId';

      print('Obteniendo estado para la orden:: $orderId');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PaymentStatusResponse.fromJson(responseData);
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return PaymentStatusResponse(
            success: false,
            message: errorData['message'] ?? 'Error del servidor',
          );
        } catch (e) {
          return PaymentStatusResponse(
            success: false,
            message: 'Error del servidor: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      print('Error in getPaymentStatus: $e');
      return PaymentStatusResponse(
        success: false,
        message: 'Error de conexión: $e',
      );
    }
  }

  /// Verifica que una orden existe y es accesible
  Future<bool> verifyOrderExists(int orderId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('${Api.baseUrl}/api/orders/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error verifying order: $e');
      return false;
    }
  }
}
