import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../models/product_model.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/product_card.dart';

class HomeSuccessView extends StatelessWidget {
  final List<Product> products;

  const HomeSuccessView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No hay productos'));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: CustomAppBar(),
          ),
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
