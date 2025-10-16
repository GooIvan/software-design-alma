import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../../models/product_model.dart';
import '../../../../../widgets/product_card.dart';
import '../../../../products/show/presentation/pages/product_screen.dart';

class ViewProductsSuccess extends StatelessWidget {
  final List<Product> products;

  const ViewProductsSuccess({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          context.l10n.noProducts,
          style: const TextStyle(fontSize: 16),
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
      ],
    );
  }
}
