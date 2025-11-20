import 'package:design_alma/feature/orders/create/data/repositories/create_order_repository.dart';
import 'package:design_alma/feature/payment/presentation/pages/payment_page.dart';
import 'package:design_alma/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../widgets/custom_alert.dart';
import '../../../../cart/data/bloc/cart_bloc.dart';
import '../../data/bloc/product_bloc.dart';
import '../widgets/bottom_buttons.dart';
import '../widgets/size_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../models/product_model.dart';
import '../.././../../cart/presentation/widgets/show_loading_dialog.dart';

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

  void _handleBuyNow(BuildContext context) async {
    if (selectedSize.value == null) {
      CustomAlert.warning(context, context.l10n.alertSizeRequired);
      return;
    }

    // Mostrar loading reutilizando tu dialog existente
    showLoadingDialog(context);

    try {
      final repository = CreateOrderRepository();

      // Crear solo 1 item para comprar ahora
      final item = {
        'product_id': product.id,
        'quantity': 1,
        'size': selectedSize.value,
      };

      // Crear orden con un SOLO producto
      final order = await repository.createOrder(
        [item],
      );

      // Cerrar loading
      if (context.mounted) {
        Navigator.of(context).pop();

        // Navegar a pago
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
                  if (product.images.isEmpty) {
                    return Column(
                      children: [
                        // Imagen principal placeholder
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
                      ],
                    );
                  }

                  return Column(
                    children: [
                      // Imagen principal (con fallback)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Image.network(
                          product.images[index],
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
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
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (product.images.length > 1)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
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
                                      errorBuilder: (_, __, ___) => Container(
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
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                    ],
                  );
                }
              ),

              const SizedBox(height: 20),

              // Precio
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$ ${NumberFormat("#,###", "es_CO").format(product.price)}",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
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

              // Texto en estilo moderno, alto legible
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
        // Botones fijos abajo
        bottomSheet: BottomButtons(
          handleAddCart: () => _handleAddCart(context),
          handleBuyNow: () => _handleBuyNow(context),
        ),
      ),
    );
  }
}
