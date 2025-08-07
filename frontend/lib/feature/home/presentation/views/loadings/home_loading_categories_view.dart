import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class HomeLoadingCategoriesView extends StatelessWidget {
  const HomeLoadingCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simular carrusel de categorías
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return const SkeletonLoader(
                width: 120, 
                height: 120, 
                borderRadius: 20,
              );
            },
          ),
        ),
      ],
    );
  }
}
