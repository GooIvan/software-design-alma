import 'package:flutter/material.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
