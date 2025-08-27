import 'package:flutter/material.dart';

class ProductLoadingView extends StatelessWidget {
  const ProductLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
