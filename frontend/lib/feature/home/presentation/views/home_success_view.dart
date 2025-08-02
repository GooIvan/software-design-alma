import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_model.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/product_card.dart';
import '../../../../widgets/square_image_widget.dart';

class HomeSuccessView extends StatelessWidget {
  final List<Product> products;
  final List<Category> categories;
  final Future<void> Function()? onRefresh;

  const HomeSuccessView({
    super.key,
    required this.products,
    required this.categories,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 300),
            Center(child: Text('No hay productos')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: CustomAppBar(),
          ),
          // Titulo de la sección
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lo nuevo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Carrusel de productos nuevos
          CarouselSlider.builder(
            itemCount: products.length,
            options: CarouselOptions(
              height: 370,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            itemBuilder: (context, index, realIdx) {
              return ProductCard(product: products[index]);
            },
          ),
          const SizedBox(height: 16),
          // Titulo de la sección 2
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Carrusel de las categorias
          CarouselSlider.builder(
              itemCount: categories.length > 5 ? 5 : products.length,
              options: CarouselOptions(
                height: 150,
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.4,
              ),
              itemBuilder: (context, index, realIdx) {
                return SquareImageWidget(
                  imageUrl: categories[index].imageUrl,
                  size: 120,
                );
              }),
        ],
      ),
    );
  }
}
