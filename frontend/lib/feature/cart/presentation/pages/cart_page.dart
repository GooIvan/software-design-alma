import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/custom_alert.dart';
import '../../data/bloc/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_empty_widget.dart';
import '../../../orders/create/data/repositories/create_order_repository.dart';
import '../../../payment/presentation/pages/payment_page.dart';
import '../widgets/show_loading_dialog.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Carrito de compras',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Limpiar carrito',
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
              // Lista de productos
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return CartItemWidget(
                      item: item,
                      onUpdateQuantity: (quantity) {
                        context.read<CartBloc>().add(
                              UpdateQuantity(
                                  itemId: item.id, quantity: quantity),
                            );
                      },
                      onRemove: () {
                        context.read<CartBloc>().add(RemoveFromCart(item.id));
                      },
                    );
                  },
                ),
              ),

              // Footer con total y botón de checkout
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Resumen del pedido
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${state.totalItems} artículo${state.totalItems != 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            state.formattedTotalPrice,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Botón de checkout
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _onCheckout(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 37, 146, 41),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Proceder al Pago',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
          title: const Text('Limpiar Carrito'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar todos los productos del carrito?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(const ClearCart());
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Limpiar'),
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
      final order = await repository.createOrderFromCart(cartState.items);

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
