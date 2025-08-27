import 'package:flutter/material.dart';

import '../../../../../models/product_model.dart';
import '../../../../../widgets/custom_alert.dart';
import '../../../../../widgets/product_card.dart';
import '../../../../products/show/presentation/pages/product_screen.dart';

class ViewProductsSuccess extends StatelessWidget {
  final List<Product> products;

  const ViewProductsSuccess({
    super.key,
    required this.products,
  });

  void _showToProduct(BuildContext context) {
    CustomAlert.warning(context, 'No hay vista del producto');
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos disponibles',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return SizedBox(
      height: 320, // altura similar al skeleton
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              print(
                  'Tocaste la categoría: "${product.name}" con id: "${product.id}"');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductScreen(
                    categoryName: product.categoryName,
                    id: product.id,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 200, // ancho similar al skeleton
              child: ProductCard(product: product),
            ),
          );
        },
      ),
    );
  }
}
