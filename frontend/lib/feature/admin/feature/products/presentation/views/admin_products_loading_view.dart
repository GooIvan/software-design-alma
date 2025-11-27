import 'package:flutter/material.dart';
import 'package:design_alma/widgets/skeleton_loader.dart';

class AdminProductsLoadingView extends StatelessWidget {
  const AdminProductsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = Theme.of(context).dividerColor;
    final bg = Theme.of(context).cardColor;

    return RefreshIndicator(
      color: Theme.of(context).textTheme.displayLarge?.color,
      onRefresh: () async {},
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Row(
                    children: [
                      SkeletonLoader(width: 150, height: 18, borderRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) {
                    return Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: const [
                            SkeletonLoader(
                              width: 60,
                              height: 60,
                              borderRadius: 10,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonLoader(
                                    width: 160,
                                    height: 16,
                                    borderRadius: 6,
                                  ),
                                  SizedBox(height: 8),
                                  SkeletonLoader(
                                    width: double.infinity,
                                    height: 14,
                                    borderRadius: 6,
                                  ),
                                  SizedBox(height: 6),
                                  SkeletonLoader(
                                    width: 80,
                                    height: 14,
                                    borderRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Row(
                    children: [
                      SkeletonLoader(width: 150, height: 18, borderRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) {
                    return Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: const [
                            SkeletonLoader(
                              width: 60,
                              height: 60,
                              borderRadius: 10,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonLoader(
                                    width: 160,
                                    height: 16,
                                    borderRadius: 6,
                                  ),
                                  SizedBox(height: 8),
                                  SkeletonLoader(
                                    width: double.infinity,
                                    height: 14,
                                    borderRadius: 6,
                                  ),
                                  SizedBox(height: 6),
                                  SkeletonLoader(
                                    width: 80,
                                    height: 14,
                                    borderRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Row(
                    children: [
                      SkeletonLoader(width: 150, height: 18, borderRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) {
                    return Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: divider, width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SkeletonLoader(
                              width: 60,
                              height: 60,
                              borderRadius: 10,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonLoader(
                                    width: 160,
                                    height: 16,
                                    borderRadius: 6,
                                  ),
                                  SizedBox(height: 8),
                                  SkeletonLoader(
                                    width: 120,
                                    height: 14,
                                    borderRadius: 6,
                                  ),
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
            ),
          ),
        ),
      ),
    );
  }
}
