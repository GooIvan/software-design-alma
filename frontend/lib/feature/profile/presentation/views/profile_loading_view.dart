import 'package:flutter/material.dart';
import '../../../../widgets/skeleton_loader.dart';

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 20),

          // Avatar shimmer
          const Center(
            child: SkeletonLoader(
              width: 100,
              height: 100,
              borderRadius: 50,
            ),
          ),

          const SizedBox(height: 20),

          // Nombre shimmer
          const Center(
            child: SkeletonLoader(
              width: 150,
              height: 20,
              borderRadius: 8,
            ),
          ),

          const SizedBox(height: 30),

          // Opciones shimmer (imitando los cards)
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4, // cantidad de opciones
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SkeletonLoader(
                        width: 24,
                        height: 24,
                        borderRadius: 6,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SkeletonLoader(
                          width: double.infinity,
                          height: 16,
                          borderRadius: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Botón shimmer
          const SkeletonLoader(
            width: double.infinity,
            height: 60,
            borderRadius: 12,
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
