import 'package:flutter/material.dart';

import '../../../../../widgets/skeleton_loader.dart';

class ViewProductsLoading extends StatelessWidget {
  const ViewProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320, // altura aproximada de la card incluyendo padding
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3, // cantidad de placeholders
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 200, // ancho de cada card
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen del producto
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

                  // Nombre del producto
                  SkeletonLoader(
                    width: double.infinity,
                    height: 20,
                    borderRadius: 8,
                  ),
                  SizedBox(height: 20),

                  // Precio + botón agregar
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
          );
        },
      ),
    );
  }
}
