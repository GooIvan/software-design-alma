import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/custom_alert.dart';
import '../../data/bloc/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_empty_widget.dart';
import '../widgets/cart_summary_widget.dart';
import '../../../orders/create/data/repositories/create_order_repository.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../widgets/show_loading_dialog.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          context.l10n.myCart,
          style: TextStyle(
            color: Theme.of(context).textTheme.displayLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showClearCartDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const CartEmptyWidget();
          }

          return Column(
            children: [
              // Lista de productos con resumen integrado
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),

                  itemCount: state.items.length + 1, // +1 para el resumen
                  itemBuilder: (context, index) {
                    // Si es el último item, mostrar el resumen
                    if (index == state.items.length) {
                      return Column(
                        children: [
                          CartSummaryWidget(
                            subtotal: state.totalPrice,
                            tax: 0, // impuesto fijo de ejemplo
                            discount: state.discountAmount,
                            total: state.finalTotal,
                            currentDiscountCode: state.appliedDiscountCode,
                            onDiscountApplied: (discountCode) {
                              if (discountCode != null) {
                                context
                                    .read<CartBloc>()
                                    .add(ApplyDiscountToCart(discountCode));
                              } else {
                                context
                                    .read<CartBloc>()
                                    .add(const RemoveDiscountFromCart());
                              }
                            },
                          ),
                        ],
                      );
                    }

                    // Mostrar items del carrito
                    final item = state.items[index];
                    return Column(
                      children: [
                        CartItemWidget(
                          item: item,
                          onUpdateQuantity: (quantity) {
                            context.read<CartBloc>().add(
                                  UpdateQuantity(
                                      itemId: item.id, quantity: quantity),
                                );
                          },
                          onRemove: () {
                            context
                                .read<CartBloc>()
                                .add(RemoveFromCart(item.id));
                          },
                        ),
                        if (index <
                            state.items.length -
                                1) // Separador solo entre items
                          const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),

              // botón de checkout
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => _onCheckout(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            context.l10n.verify,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.l10n.clearCart),
          content: Text(context.l10n.clearCartConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(const ClearCart());
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(context.l10n.clear),
            ),
          ],
        );
      },
    );
  }

  void _onCheckout(BuildContext context) async {
    final cartState = context.read<CartBloc>().state;

    // Mostrar loading
    showLoadingDialog(context);

    try {
      final repository = CreateOrderRepository();
      final order = await repository.createOrderFromCart(
        cartState.items,
        discountCode: cartState.appliedDiscountCode?.code,
      );

      // Cerrar loading
      if (context.mounted) {
        Navigator.of(context).pop();

        // Limpiar carrito después de crear la orden exitosamente
        context.read<CartBloc>().add(const ClearCart());

        // Navegar a la página de pago
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(orderId: order.id),
          ),
        );
      }
    } catch (e) {
      // Cerrar loading
      if (context.mounted) {
        Navigator.of(context).pop();
        CustomAlert.error(
          context,
          e.toString().replaceFirst(RegExp(r'^Exception:\s*'), ''),
        );
      }
    }
  }
}
