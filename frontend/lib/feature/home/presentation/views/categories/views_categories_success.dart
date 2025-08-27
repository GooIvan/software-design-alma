import 'package:flutter/material.dart';
import '../../../../../models/category_model.dart';
import '../../../../../widgets/square_image_widget.dart';
import '../../../../products/index/presentation/pages/products_screen.dart';

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

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              print('Tocaste la categoría: "${category.name}"');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ProductsScreen(categoryName: category.name),
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
    );
  }
}
