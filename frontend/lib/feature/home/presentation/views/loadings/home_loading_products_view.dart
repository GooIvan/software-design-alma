import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class HomeLoadingProductsView extends StatelessWidget {
  const HomeLoadingProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simular carrusel de productos
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return const SkeletonLoader(
                width: 200, 
                height: 280, 
                borderRadius: 20,
              );
            },
          ),
        ),
      ],
    );
  }
}
