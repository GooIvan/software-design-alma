import 'dart:convert';
import 'package:design_alma/global/api.dart';
import 'package:http/http.dart' as http;

import '../../../../models/product_model.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts(String categoryName) async {
    final response = await http.get(
      Uri.parse('${Api.baseUrl}/api/categories/$categoryName/products'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al cargar productos para la categoría $categoryName');
    }
  }
}
