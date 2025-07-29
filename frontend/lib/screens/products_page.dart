import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String formattedPrice;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.formattedPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      formattedPrice: json['formatted_price'],
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://192.168.101.108:3000/api/products'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(product.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            title: Text(product.name),
            subtitle: Text(product.formattedPrice),
          );
        },
      ),
    );
  }
}
