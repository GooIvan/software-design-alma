import 'package:flutter/material.dart';
import '../../../../widgets/skeleton_loader.dart';

class LoginLoadingView extends StatelessWidget {
  const LoginLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar skeleton
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor ??
                      Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const SkeletonLoader(
                  width: 50,
                  height: 50,
                  borderRadius: 25,
                ),
              ),
              const SizedBox(height: 20),

              // Título skeleton
              const SkeletonLoader(
                width: 250,
                height: 32,
                borderRadius: 8,
              ),
              const SizedBox(height: 6),

              // Subtítulo skeleton
              const SkeletonLoader(
                width: 180,
                height: 20,
                borderRadius: 6,
              ),
              const SizedBox(height: 30),

              // Email field skeleton
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor ??
                      Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    children: [
                      SkeletonLoader(width: 20, height: 20, borderRadius: 4),
                      SizedBox(width: 12),
                      Expanded(
                        child: SkeletonLoader(
                            width: double.infinity,
                            height: 20,
                            borderRadius: 4),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password field skeleton
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor ??
                      Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    children: [
                      SkeletonLoader(width: 20, height: 20, borderRadius: 4),
                      SizedBox(width: 12),
                      Expanded(
                        child: SkeletonLoader(
                            width: double.infinity,
                            height: 20,
                            borderRadius: 4),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Forgot password skeleton
              const Align(
                alignment: Alignment.centerRight,
                child: SkeletonLoader(
                  width: 160,
                  height: 16,
                  borderRadius: 4,
                ),
              ),

              const SizedBox(height: 20),

              // Login button skeleton
              const SkeletonLoader(
                width: double.infinity,
                height: 40,
              ),

              const SizedBox(height: 10),

              // Social login skeleton section
              Column(
                children: [
                  // Divider
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: Theme.of(context).dividerColor,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("o",
                            style: TextStyle(
                                color: Theme.of(context).dividerColor,
                                fontSize: 16)),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: Theme.of(context).dividerColor,
                      )),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Social buttons skeletons
                  ...List.generate(
                      3,
                      (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 90),
                                child: Row(
                                  children: [
                                    SkeletonLoader(
                                        width: 24, height: 24, borderRadius: 6),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: SkeletonLoader(
                                          width: double.infinity,
                                          height: 16,
                                          borderRadius: 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),

                  const SizedBox(height: 20),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkeletonLoader(
                        width: 130,
                        height: 17,
                      ),
                      SizedBox(width: 12),
                      SkeletonLoader(
                        width: 100,
                        height: 17,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
