import 'package:design_alma/feature/favorites/data/bloc/favorites_bloc.dart';
import 'package:design_alma/feature/orders/create/data/repositories/create_order_repository.dart';
import 'package:design_alma/feature/payment/presentation/pages/payment_page.dart';
import 'package:design_alma/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../widgets/custom_alert.dart';
import '../../../../cart/data/bloc/cart_bloc.dart';
import '../../../../cart/presentation/widgets/show_loading_dialog.dart';
import '../../data/bloc/product_bloc.dart';
import '../widgets/bottom_buttons.dart';
import '../widgets/size_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../models/product_model.dart';

class ProductSuccessView extends StatelessWidget {
  final Product product;

  // controladores reactivos
  final ValueNotifier<int> selectedImage = ValueNotifier(0);
  final ValueNotifier<String?> selectedSize = ValueNotifier<String?>(null);

  ProductSuccessView({super.key, required this.product});

  // ------------------------------------------
  //  AGREGAR AL CARRITO
  // ------------------------------------------
  void _handleAddCart(BuildContext context) {
    final cartBloc = context.read<CartBloc>();

    if (selectedSize.value == null) {
      CustomAlert.warning(context, context.l10n.alertSizeRequired);
      return;
    }

    cartBloc.add(
      AddToCart(
        product: product,
        size: selectedSize.value!,
        quantity: 1,
      ),
    );

    CustomAlert.success(context, context.l10n.productAddedToCart);

    selectedSize.value = null;
  }

  // ------------------------------------------
  //  COMPRAR YA
  // ------------------------------------------
  void _handleBuyNow(BuildContext context) async {
    if (selectedSize.value == null) {
      CustomAlert.warning(context, context.l10n.alertSizeRequired);
      return;
    }

    showLoadingDialog(context);

    try {
      final repository = CreateOrderRepository();

      final item = {
        'product_id': product.id,
        'quantity': 1,
        'size': selectedSize.value,
      };

      final order = await repository.createOrder([item]);

      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(orderId: order.id),
          ),
        );
      }
    } catch (e) {
      // Cerrar loading y mostrar error
      if (context.mounted) {
        Navigator.of(context).pop();
        CustomAlert.error(
          context,
          e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
        );
      }
    }
  }

  // ------------------------------------------
  //  BUILD
  // ------------------------------------------
  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoritesUnauthenticated) {
          CustomAlert.show(
            context,
            context.l10n.login,
            AlertType.warning,
          );
          context.read<FavoritesBloc>().add(ResetFavoritesState());
        }
      },
      child: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          context.read<ProductBloc>().add(
                RefreshProduct(
                  product.categoryName,
                  product.id,
                ),
              );
        },
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Categoria
                Text(
                  product.categoryName,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                // Nombre
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),

                const SizedBox(height: 16),

                // Imagen y miniaturas
                ValueListenableBuilder<int>(
                  valueListenable: selectedImage,
                  builder: (context, index, _) {
                    if (product.images.isEmpty) {
                      return _buildPlaceholderImage(context);
                    }

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Image.network(
                            product.images[index],
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _errorImageBox(),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: _FavoriteButton(product: product),
                        ),
                        if (product.images.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: _buildThumbnails(context, index),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Precio
                Text(
                  "\$ ${NumberFormat("#,###", "es_CO").format(product.price)}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 20),

                // Tallas
                Text(
                  context.l10n.selectSize,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),

                SizeSelector(
                  sizes: product.sizes,
                  selectedSizeNotifier: selectedSize,
                  onSizeSelected: (size) {
                    selectedSize.value = size;
                  },
                ),

                const SizedBox(height: 20),

                // Descripción
                Text(
                  context.l10n.description,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.color
                        ?.withOpacity(0.85),
                  ),
                ),

                const SizedBox(height: 140),
              ],
            ),
          ),

          // Botones fijos
          bottomSheet: BottomButtons(
            handleAddCart: () => _handleAddCart(context),
            handleBuyNow: () => _handleBuyNow(context),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Helpers UI
  // ---------------------------------------------------------
  Widget _buildPlaceholderImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 80,
            color: Colors.grey,
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: _FavoriteButton(product: product),
        ),
      ],
    );
  }

  Widget _errorImageBox() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 80,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildThumbnails(BuildContext context, int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(product.images.length, (i) {
          return GestureDetector(
            onTap: () => selectedImage.value = i,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: i == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.images[i],
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _errorThumb(),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _errorThumb() {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.image,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final Product product;
  const _FavoriteButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (_, state) {
        bool isFavorite = false;

        if (state is FavoritesLoaded) {
          isFavorite = state.favorites.any((f) => f.product.id == product.id);
        }

        return GestureDetector(
          onTap: () {
            if (!isFavorite) {
              context.read<FavoritesBloc>().add(AddFavorite(product.id));
            } else {
              context.read<FavoritesBloc>().add(RemoveFavorite(product.id));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
