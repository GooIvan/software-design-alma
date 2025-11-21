import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class FavoritesLoadingView extends StatelessWidget {
  const FavoritesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.6,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color:
                Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
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
                SizedBox(height: 18),

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
    );
  }
}
