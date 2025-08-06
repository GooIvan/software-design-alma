import 'package:flutter/material.dart';
import '../../../../widgets/skeleton_loader.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Título "Lo nuevo"
        const SkeletonLoader(width: 120, height: 24),

        const SizedBox(height: 16),

        // Simular carrusel de productos
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return const SkeletonLoader(
                  width: 200, height: 280, borderRadius: 20);
            },
          ),
        ),

        const SizedBox(height: 24),

        // Título "Categorías"
        const SkeletonLoader(width: 120, height: 24),

        const SizedBox(height: 16),

        // Simular categorías
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return const SkeletonLoader(
                  width: 120, height: 120, borderRadius: 20);
            },
          ),
        ),
      ],
    );
  }
}
