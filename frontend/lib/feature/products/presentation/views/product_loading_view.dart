import 'package:flutter/material.dart';
import '../../../../widgets/skeleton_loader.dart';

class ProductLoadingView extends StatelessWidget {
  const ProductLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return const SkeletonLoader(
            width: 200,
            height: 280,
            borderRadius: 20,
          );
        },
      ),
    );
  }
}
