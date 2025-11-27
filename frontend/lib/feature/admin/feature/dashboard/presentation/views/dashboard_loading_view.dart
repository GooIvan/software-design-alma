import 'package:flutter/material.dart';
import 'package:design_alma/widgets/skeleton_loader.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).textTheme.displayLarge?.color,
      onRefresh: () async {},
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(4, (index) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SkeletonLoader(
                                  width: 60,
                                  height: 16,
                                  borderRadius: 8,
                                ),
                                SizedBox(height: 8),
                                SkeletonLoader(
                                  width: 80,
                                  height: 12,
                                  borderRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          SkeletonLoader(
                            width: 40,
                            height: 40,
                            borderRadius: 20,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Simulación del gráfico de líneas
                const SkeletonLoader(
                  width: double.infinity,
                  height: 200,
                  borderRadius: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
