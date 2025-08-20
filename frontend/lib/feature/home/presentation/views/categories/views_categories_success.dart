import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../../models/category_model.dart';
import '../../../../../widgets/square_image_widget.dart';
import '../../../../products/presentation/pages/product_screen.dart';

class ViewCategoriesSuccess extends StatelessWidget {
  final List<Category> categories;

  const ViewCategoriesSuccess({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'No hay categorías disponibles',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          itemCount: categories.length,
          options: CarouselOptions(
            height: 150,
            enlargeCenterPage: false,
            autoPlay: false,
            viewportFraction: 0.4,
          ),
          itemBuilder: (context, index, realIdx) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                print('Tocaste la categoría: "${category.name}"');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(categoryName: category.name),
                  ),
                );
              },
              child: SquareImageWidget(
                imageUrl: category.imageUrl,
                size: 120,
              ),
            );
          },
        ),
      ],
    );
  }
}
