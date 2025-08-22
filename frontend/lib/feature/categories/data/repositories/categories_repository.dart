import 'dart:convert';
import 'package:design_alma/global/api.dart';
import 'package:http/http.dart' as http;

import '../../../../models/category_model.dart';

class CategoryRepository {
  Future<List<Category>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('${Api.baseUrl}/api/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }
}
