import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class ViewsCategoriesLoading extends StatelessWidget {
  const ViewsCategoriesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // misma altura que el carrusel
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5, // cantidad de placeholders
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return const SkeletonLoader(
            width: 120, // igual que SquareImageWidget(size: 120)
            height: 120,
            borderRadius: 20, // igual al borderRadius de SquareImageWidget
          );
        },
      ),
    );
  }
}
