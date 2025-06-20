
import 'package:flutter/material.dart';
import '../../model/product_model.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.image, width: 60, height: 60),
      title: Text(product.name),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
    );
  }
}
