import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryRepository {
  final String _baseUrl = 'https://mocki.io/v1/f8ba5803-eed5-4492-b782-5350de5c3595';

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CategoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}