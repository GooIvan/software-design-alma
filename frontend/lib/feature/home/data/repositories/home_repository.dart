import 'dart:convert';
import 'package:design_alma/global/api.dart';
import 'package:http/http.dart' as http;

import '../../../../models/product_model.dart';
import '../../../../models/category_model.dart';

class HomeRepository {
  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('${Api.baseUrl}/api/products/latest'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${Api.baseUrl}/api/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }
}
