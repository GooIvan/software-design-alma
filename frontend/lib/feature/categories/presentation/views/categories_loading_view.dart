import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/skeleton_loader.dart';

class CategoriesLoadingView extends StatelessWidget {
  const CategoriesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              context.l10n.categories,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Skeleton con shimmer
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 6, // cantidad de placeholders
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Imagen cuadrada shimmer
                    SkeletonLoader(
                      width: 60,
                      height: 60,
                      borderRadius: 8,
                    ),
                    SizedBox(width: 16),

                    // Texto shimmer
                    Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 20,
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
