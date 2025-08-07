import 'dart:convert';
import 'package:design_alma/global/api.dart';
import 'package:http/http.dart' as http;

import '../../../../models/product_model.dart';
import '../../../../models/category_model.dart';

class HomeRepository {
  // Cache simple para evitar llamadas innecesarias
  List<Product>? _cachedProducts;
  List<Category>? _cachedCategories;
  DateTime? _lastProductsFetch;
  DateTime? _lastCategoriesFetch;

  // Cache duration (5 minutos)
  static const Duration _cacheDuration = Duration(minutes: 5);

  Future<List<Product>> fetchProducts() async {
    // Verificar si tenemos caché válido
    if (_cachedProducts != null &&
        _lastProductsFetch != null &&
        DateTime.now().difference(_lastProductsFetch!) < _cacheDuration) {
      print('📦 Usando productos del caché');
      return _cachedProducts!;
    }

    return _fetchProductsFromServer();
  }

  Future<List<Category>> fetchCategories() async {
    // Verificar si tenemos caché válido
    if (_cachedCategories != null &&
        _lastCategoriesFetch != null &&
        DateTime.now().difference(_lastCategoriesFetch!) < _cacheDuration) {
      print('📦 Usando categorías del caché');
      return _cachedCategories!;
    }

    return _fetchCategoriesFromServer();
  }

  // Métodos para refresh que ignoran el caché
  Future<List<Product>> refreshProducts() async {
    print('🔄 Refresh: Obteniendo productos del servidor (ignorando caché)');
    return _fetchProductsFromServer();
  }

  Future<List<Category>> refreshCategories() async {
    print('🔄 Refresh: Obteniendo categorías del servidor (ignorando caché)');
    return _fetchCategoriesFromServer();
  }

  // Métodos privados para las llamadas al servidor
  Future<List<Product>> _fetchProductsFromServer() async {
    print('🌐 Obteniendo productos del servidor');
    final response =
        await http.get(Uri.parse('${Api.baseUrl}/api/products/latest'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _cachedProducts = data.map((json) => Product.fromJson(json)).toList();
      _lastProductsFetch = DateTime.now();
      return _cachedProducts!;
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  Future<List<Category>> _fetchCategoriesFromServer() async {
    print('🌐 Obteniendo categorías del servidor');
    final response = await http.get(Uri.parse('${Api.baseUrl}/api/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _cachedCategories = data.map((json) => Category.fromJson(json)).toList();
      _lastCategoriesFetch = DateTime.now();
      return _cachedCategories!;
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  // Método para limpiar caché manualmente (útil para refresh)
  void clearCache() {
    _cachedProducts = null;
    _cachedCategories = null;
    _lastProductsFetch = null;
    _lastCategoriesFetch = null;
  }
}
