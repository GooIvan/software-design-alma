import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/discount_code_model.dart';
import '../global/api.dart';

class DiscountCodeService {
  /// Obtener token de autenticación
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Obtener headers para las peticiones
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Validar un código de descuento
  /// [code] - El código a validar
  /// [subtotal] - Opcional: subtotal para calcular el descuento
  Future<DiscountCodeValidation> validateDiscountCode(
    String code, {
    double? subtotal,
  }) async {
    try {
      final Map<String, dynamic> body = {'code': code};
      if (subtotal != null) {
        body['subtotal'] = subtotal;
      }

      final response = await http.post(
        Uri.parse('${Api.baseUrl}/api/discount_codes/validate'),
        headers: await _getHeaders(),
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return DiscountCodeValidation.fromJson(data);
      } else {
        return DiscountCodeValidation.fromJson({
          'success': false,
          'valid': false,
          'message': data['message'] ?? 'Código de descuento inválido',
        });
      }
    } catch (e) {
      // En desarrollo, podemos usar print para debug
      // ignore: avoid_print
      print('Error validating discount code: $e');
      return const DiscountCodeValidation(
        success: false,
        valid: false,
        message: 'Error de conexión al validar código',
      );
    }
  }

  /// Obtener códigos de descuento disponibles para el usuario
  Future<List<DiscountCode>> getAvailableDiscountCodes() async {
    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/api/discount_codes/available'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['discount_codes'] != null) {
          return (data['discount_codes'] as List)
              .map((json) => DiscountCode.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      // ignore: avoid_print
      print('Error getting available discount codes: $e');
      return [];
    }
  }

  /// Aplicar código de descuento y obtener información actualizada
  /// [code] - Código de descuento
  /// [subtotal] - Subtotal de la orden
  Future<DiscountCode?> applyDiscountCode(String code, double subtotal) async {
    final validation = await validateDiscountCode(code, subtotal: subtotal);

    if (validation.success && validation.valid) {
      return validation.discountCode;
    }

    return null;
  }

  /// Calcular total con descuento
  /// [subtotal] - Subtotal original
  /// [discountCode] - Código de descuento aplicado
  Map<String, double> calculateTotals(
      double subtotal, DiscountCode? discountCode) {
    double discountAmount = 0.0;

    if (discountCode != null && discountCode.isValid) {
      discountAmount = discountCode.calculateDiscount(subtotal);
    }

    final total = subtotal - discountAmount;

    return {
      'subtotal': subtotal,
      'discount': discountAmount,
      'total': total,
    };
  }

  /// Formatear cantidad de dinero para mostrar
  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  /// Obtener mensaje descriptivo para un código inválido
  String getInvalidCodeMessage(String code) {
    // Estos mensajes coinciden con los de la API
    return 'El código "$code" no es válido o ha expirado';
  }

  /// Obtener color para mostrar el estado del código
  String getDiscountCodeColor(DiscountCode discountCode) {
    if (!discountCode.isValid) {
      return '#EF4444'; // Rojo para inválidos
    }
    if (discountCode.isPercentage && discountCode.value >= 50) {
      return '#DC2626'; // Rojo para descuentos altos
    }
    if (discountCode.isPercentage && discountCode.value >= 25) {
      return '#EA580C'; // Naranja para descuentos medianos
    }
    return '#059669'; // Verde para descuentos normales
  }

  /// Validar formato básico del código antes de enviar a la API
  bool isValidCodeFormat(String code) {
    // Validaciones básicas del formato
    if (code.isEmpty) return false;
    if (code.length < 3) return false;
    if (code.length > 50) return false;

    // Solo letras, números y algunos caracteres especiales
    final regex = RegExp(r'^[A-Z0-9\-_]{3,50}$');
    return regex.hasMatch(code.toUpperCase());
  }

  /// Normalizar código (convertir a mayúsculas, eliminar espacios)
  String normalizeCode(String code) {
    return code.trim().toUpperCase().replaceAll(' ', '');
  }

  /// Obtener descripción del tipo de descuento
  String getDiscountTypeDescription(DiscountCode discountCode) {
    if (discountCode.isPercentage) {
      return 'Descuento del ${discountCode.value.toInt()}%';
    } else {
      return 'Descuento fijo de ${formatCurrency(discountCode.value)}';
    }
  }

  /// Verificar si un código ya fue usado por el usuario
  Future<bool> isCodeUsedByUser(String code) async {
    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/api/discount_codes/usage_status?code=$code'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['used'] == true;
      }

      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Error checking discount code usage: $e');
      return false;
    }
  }

  /// Obtener estadísticas de uso de códigos de descuento
  Future<Map<String, dynamic>?> getDiscountStats() async {
    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}/api/discount_codes/stats'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['stats'];
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting discount stats: $e');
      return null;
    }
  }
}
