import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../../models/product_model.dart';
import '../../../../../widgets/custom_alert.dart';
import '../../../../../widgets/product_card.dart';

class ViewProductsSuccess extends StatelessWidget {
  final List<Product> products;

  const ViewProductsSuccess({
    super.key,
    required this.products,
  });

  void _showToProduct(BuildContext context) {
    // Aquí puedes implementar la navegación a la vista del producto
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          itemCount: products.length,
          options: CarouselOptions(
            height: 300,
            enlargeCenterPage: false,
            autoPlay: true,
            viewportFraction: 0.5,
          ),
          itemBuilder: (context, index, realIdx) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                print('Tocaste el producto: "${product.name}"');
                _showToProduct(context);
              },
              child: ProductCard(product: product),
            );
          },
        ),
      ],
    );
  }
}
