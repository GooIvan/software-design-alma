import 'dart:convert';
import 'package:design_alma/global/api.dart';
import 'package:http/http.dart' as http;

import '../../../../../models/product_model.dart';

class ProductRepository {
  Future<Product> fetchProduct(String categoryName, int id) async {
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/api/categories/$categoryName/products/$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Error al cargar producto');
    }
  }
}
