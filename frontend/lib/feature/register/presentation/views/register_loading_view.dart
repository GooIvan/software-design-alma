import 'package:flutter/material.dart';
import '../../../../widgets/skeleton_loader.dart';
import '../widgets/input_skeleton_loading.dart';

class RegisterLoadingView extends StatelessWidget {
  const RegisterLoadingView({
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
              // Título skeleton
              const SkeletonLoader(
                width: 350,
                height: 32,
                borderRadius: 8,
              ),
              const SizedBox(height: 6),

              // Subtítulo skeleton
              const SkeletonLoader(
                width: 230,
                height: 20,
                borderRadius: 6,
              ),
              const SizedBox(height: 30),

              // name field skeleton
              const InputSkeletonLoading(),
              const SizedBox(height: 13),

              // last name field skeleton
              const InputSkeletonLoading(),
              const SizedBox(height: 13),

              // city field skeleton
              const InputSkeletonLoading(),
              const SizedBox(height: 13),

              // Adress field skeleton
              const InputSkeletonLoading(),
              const SizedBox(height: 13),

              // Phone field skeleton
              const InputSkeletonLoading(),
              const SizedBox(height: 13),

              // Email field skeleton
              const InputSkeletonLoading(),
              const SizedBox(height: 13),

              // Password field skeleton
              const InputSkeletonLoading(),
              const SizedBox(height: 13),

              // Confirm password field skeleton
              const InputSkeletonLoading(),
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
