import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/product_model.dart';
import '../../../../../widgets/custom_alert.dart';
import '../../../../../widgets/product_card.dart';
import '../../../../favorites/data/bloc/favorites_bloc.dart';
import '../../data/bloc/products_bloc.dart'; // 👈 corregí el import

class ProductsSuccessView extends StatelessWidget {
  final List<Product> products;

  const ProductsSuccessView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesUnauthenticated) {
          CustomAlert.show(
            context,
            'Debes iniciar sesión para agregar a favoritos.',
            AlertType.warning,
          );
          // Reset state so alert can be shown again
          context.read<FavoritesBloc>().add(ResetFavoritesState());
        }
      },
      child: RefreshIndicator(
        color: Theme.of(context).textTheme.displayLarge?.color,
        onRefresh: () async {
          // Aquí mandamos el evento correcto
          context
              .read<ProductsBloc>()
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
            return ProductCard(product: products[index], showCategory: false);
          },
        ),
      ),
    );
  }
}
