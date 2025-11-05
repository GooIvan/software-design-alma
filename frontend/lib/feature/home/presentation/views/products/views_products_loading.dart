import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../../widgets/skeleton_loader.dart';

class ViewProductsLoading extends StatelessWidget {
  const ViewProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 3, // cantidad de placeholders
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: false,
        autoPlay: false,
        viewportFraction: 0.5, // igual que en el success
      ),
      itemBuilder: (context, index, realIdx) {
        return SizedBox(
          width: 200, // mismo ancho que en el success
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Theme.of(context).appBarTheme.backgroundColor ??
                      Colors.white,
                  width: 1),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen
                  Expanded(
                    child: SkeletonLoader(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 16,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Categoría
                  SkeletonLoader(
                    width: 80,
                    height: 14,
                    borderRadius: 8,
                  ),
                  SizedBox(height: 6),

                  // Nombre
                  SkeletonLoader(
                    width: double.infinity,
                    height: 20,
                    borderRadius: 8,
                  ),
                  SizedBox(height: 20),

                  // Precio + botón
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLoader(
                        width: 60,
                        height: 20,
                        borderRadius: 8,
                      ),
                      SkeletonLoader(
                        width: 32,
                        height: 32,
                        borderRadius: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
