import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../feature/cart/data/bloc/cart_bloc.dart';
import '../feature/favorites/data/bloc/favorites_bloc.dart';
import '../feature/products/show/presentation/pages/product_screen.dart';
import '../models/product_model.dart';
import 'custom_alert.dart';

class ProductCard extends StatelessWidget {
  final showCategory;
  final Product product;

  const ProductCard(
      {super.key, required this.product, this.showCategory = true});

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product.stock == 0;

    return IgnorePointer(
      ignoring: isOutOfStock,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          // 👉 Si NO hay stock, desactivamos el tap
          onTap: isOutOfStock
              ? null
              : () {
                  print(
                    'Tocaste el producto: "${product.name}" con id: "${product.id}"',
                  );

                  String categorySlug =
                      product.categoryName.toLowerCase().replaceAll(' ', '-');

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductScreen(
                        categoryName: categorySlug,
                        id: product.id,
                      ),
                    ),
                  );
                },
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // --- CONTENIDO NORMAL ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen con favoritos
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: product.images.isEmpty
                                ? _buildFallback(context)
                                : Image.network(
                                    product.images.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: isOutOfStock
                                        ? Colors.white.withOpacity(0.7)
                                        : null,
                                    colorBlendMode: isOutOfStock
                                        ? BlendMode.modulate
                                        : null,
                                  ),
                          ),
                        ),

                        // Banner AGOTADO
                        if (isOutOfStock)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                context.l10n.soldOut,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),

                        // Botón favoritos
                        Positioned(
                          top: 12,
                          right: 12,
                          child: BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, state) {
                              bool isFavorite = false;

                              if (state is FavoritesLoaded) {
                                isFavorite = state.favorites.any(
                                  (fav) => fav.product.id == product.id,
                                );
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (!isFavorite) {
                                    context
                                        .read<FavoritesBloc>()
                                        .add(AddFavorite(product.id));
                                  } else {
                                    context
                                        .read<FavoritesBloc>()
                                        .add(RemoveFavorite(product.id));
                                  }
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor ??
                                        Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 22,
                                    color: isFavorite
                                        ? Colors.red
                                        : const Color(0xFF6C7175),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Precio
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.price,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  "\$${product.formattedPrice}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF29B6F6),
                                  ),
                                ),
                              ],
                            ),

                            // Botón agregar
                            Container(
                              decoration: BoxDecoration(
                                gradient: isOutOfStock
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          Color(0xFF29B6F6),
                                          Color(0xFF1976D2),
                                        ],
                                      ),
                                color: isOutOfStock ? Colors.grey[400] : null,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isOutOfStock
                                      ? null
                                      : () => _showSizeSelector(context),
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSizeSelector(BuildContext context) {
    final cartBloc = context.read<CartBloc>(); // Obtener CartBloc del contexto

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (_) => cartBloc,
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.selectSize,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Producto info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.images.first,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${product.formattedPrice}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Lista de tallas
                if (product.sizes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(context.l10n.noSizes),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.l10n.sizesAvailable}:',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.sizes.map((size) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _addToCart(context, size);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor ??
                                      Colors.white,
                                ),
                                child: Text(
                                  size,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context, String selectedSize) {
    // Agregar al carrito usando BLoC
    context.read<CartBloc>().add(
          AddToCart(
            product: product,
            size: selectedSize,
            quantity: 1,
          ),
        );

    // Mostrar mensaje de éxito
    CustomAlert.success(context, context.l10n.aggProductToCart);

    print('Producto agregado al carrito: "${product.name}", "$selectedSize"');
  }

  /// 🔘 --- WIDGET FALLBACK --- 🔘
  /// Fondo gris + ícono + texto
  Widget _buildFallback(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_not_supported_outlined,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.noImage,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
