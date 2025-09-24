import 'package:flutter/material.dart';

import '../../../../widgets/skeleton_loader.dart';

class InputSkeletonLoading extends StatelessWidget {
  const InputSkeletonLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
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
                  width: double.infinity, height: 20, borderRadius: 4),
            ),
          ],
        ),
      ),
    );
  }
}
