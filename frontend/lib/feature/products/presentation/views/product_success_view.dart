import 'package:flutter/material.dart';

import '../../../../models/product_model.dart';

class ProductSuccessView extends StatelessWidget {
  final List<Product> products;

  const ProductSuccessView({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index].name),
        );
      },
    );
  }
}