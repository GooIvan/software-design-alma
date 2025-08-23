import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/product_model.dart';
import '../../../../widgets/product_card.dart';
import '../../../products/data/bloc/product_bloc.dart'; // 👈 corregí el import

class ProductSuccessView extends StatelessWidget {
  final List<Product> products;

  const ProductSuccessView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        // Aquí mandamos el evento correcto
        context
            .read<ProductBloc>()
            .add(RefreshProducts(products.first.categoryName));
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.6,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}
