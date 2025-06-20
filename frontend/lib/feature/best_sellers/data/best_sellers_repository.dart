
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class BestSellersRepository {
  static const _url = 'https://run.mocky.io/v3/12345678-abcd-1234-ef00-1234567890ab';

  Future<List<Product>> fetchBestSellers() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}
