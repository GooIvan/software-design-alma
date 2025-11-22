import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../models/favorite_model.dart';
import '../../../../../widgets/product_card.dart';
import '../widgets/empty_favorites_page.dart'; // 👈 IMPORTANTE
import '../../data/bloc/favorites_bloc.dart';

class FavoritesSuccessView extends StatelessWidget {
  final List<Favorite> favorites;

  const FavoritesSuccessView({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    // 👇 Si está vacío, mostrar tu pantalla personalizada
    if (favorites.isEmpty) {
      return const EmptyFavoritesPage();
    }

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        context.read<FavoritesBloc>().add(RefreshFavorites());
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.6,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: favorites[index].product,
            showCategory: false,
          );
        },
      ),
    );
  }
}
