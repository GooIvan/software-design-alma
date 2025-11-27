import 'package:flutter/material.dart';
import '../../../../../../widgets/skeleton_loader.dart';

class UsersLoadingView extends StatelessWidget {
  const UsersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _filtersSkeleton(context),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar circular
                    Container(
                      width: 58,
                      height: 58,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.dividerColor.withOpacity(.5),
                          width: 2,
                        ),
                      ),
                      child: const SkeletonLoader(
                        width: 55,
                        height: 55,
                        borderRadius: 50,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Texto principal + chips falsos
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre
                          SkeletonLoader(
                            width: 140,
                            height: 18,
                            borderRadius: 8,
                          ),
                          SizedBox(height: 6),

                          // Email
                          SkeletonLoader(
                            width: 200,
                            height: 14,
                            borderRadius: 8,
                          ),
                          SizedBox(height: 12),

                          // Chips falsos
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              SkeletonLoader(
                                width: 60,
                                height: 24,
                                borderRadius: 8,
                              ),
                              SkeletonLoader(
                                width: 40,
                                height: 24,
                                borderRadius: 8,
                              ),
                              SkeletonLoader(
                                width: 70,
                                height: 24,
                                borderRadius: 8,
                              ),
                            ],
                          )
                        ],
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

  Widget _filtersSkeleton(BuildContext context) {
    final borderColor = Theme.of(context).dividerColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor, width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search
          SkeletonLoader(
            width: double.infinity,
            height: 42,
            borderRadius: 10,
          ),
          SizedBox(height: 14),

          // Combo Boxes (2 columnas)
          Row(
            children: [
              Expanded(
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 42,
                  borderRadius: 10,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 42,
                  borderRadius: 10,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Reset button
          Align(
            alignment: Alignment.centerRight,
            child: SkeletonLoader(
              width: 100,
              height: 18,
              borderRadius: 6,
            ),
          ),
        ],
      ),
    );
  }
}
