import 'package:design_alma/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../widgets/custom_alert.dart';
import '../../../../cart/data/bloc/cart_bloc.dart';
import '../../data/bloc/product_bloc.dart';
import '../widgets/bottom_buttons.dart';
import '../widgets/size_selector.dart';
import 'package:flutter/material.dart';
import '../../../../../models/product_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductSuccessView extends StatelessWidget {
  final Product product;

  // controlador reactivo para manejar la imagen seleccionada
  final ValueNotifier<int> selectedImage = ValueNotifier(0);

  // controlador reactivo para manejar la talla seleccionada
  final ValueNotifier<String?> selectedSize = ValueNotifier<String?>(null);

  ProductSuccessView({super.key, required this.product});

  void _handleAddCart(BuildContext context) {
    final cartBloc = context.read<CartBloc>(); // Obtener CartBloc del contexto

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

    print('Producto agregado al carrito: "${product.name}", "$selectedSize"');

    // Limpiar la talla seleccionada
    selectedSize.value = null;
  }

  void _handleBuyNow(BuildContext context) {
    if (selectedSize.value == null) {
      CustomAlert.warning(context, context.l10n.alertSizeRequired);
      return;
    }
    CustomAlert.warning(context, context.l10n.functionalityNotImplemented);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        // Aquí mandamos el evento correcto
        context.read<ProductBloc>().add(RefreshProduct(
              product.categoryName,
              product.id,
            ));
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

              // Imagen del producto (carrusel)
              ValueListenableBuilder<int>(
                valueListenable: selectedImage,
                builder: (context, index, _) {
                  return Column(
                    children: [
                      // Imagen principal
                      ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Image.network(
                          product.images[index],
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Miniaturas
                      if (product.images.length > 1)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(product.images.length, (i) {
                              return GestureDetector(
                                onTap: () => selectedImage.value = i,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: i == index
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        10), // un poquito más grande
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8), // un poquito más pequeño
                                    child: Image.network(
                                      product.images[i],
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Talla
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
                selectedSizeNotifier:
                    selectedSize, // <- se pasa el ValueNotifier
                onSizeSelected: (size) {
                  selectedSize.value = size; // ✅ se mantiene sincronizado
                },
              ),

              const SizedBox(height: 20),

              // Descripcion
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
                  color: Theme.of(context).textTheme.displayLarge?.color,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        // Botones fijos abajo
        bottomSheet: BottomButtons(
          handleAddCart: () => _handleAddCart(context),
          handleBuyNow: () => _handleBuyNow(context),
        ),
      ),
    );
  }
}
