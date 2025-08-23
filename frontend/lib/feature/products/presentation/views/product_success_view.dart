import 'package:flutter/material.dart';
import '../../../../models/product_model.dart';
import '../../../../widgets/product_card.dart';

class ProductSuccessView extends StatelessWidget {
  final List<Product> products;

  const ProductSuccessView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // ✅ Dos columnas
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio:
            0.6, // Ajusta este valor para hacer las tarjetas más altas
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
