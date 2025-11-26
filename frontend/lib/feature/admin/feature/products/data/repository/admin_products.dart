import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../global/api.dart';
import '../../../../models/dashboard_model.dart';

class AdminProductsRepository {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<DashboardModel> fetchAdminProducts() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${Api.baseUrl}/api/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DashboardModel.fromJson(data);
    } else {
      throw Exception(
        'Error al cargar los productos en admin: ${response.statusCode} - ${response.reasonPhrase}\n${response.body}',
      );
    }
  }
}
