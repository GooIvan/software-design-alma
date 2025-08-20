import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/data/bloc/product/product_bloc.dart';

class ProductErrorView extends StatelessWidget {
  const ProductErrorView({
    super.key,
    required this.categoryName,
    required this.message,
  });

  final String categoryName;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(LoadProducts());
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
