import 'package:design_alma/feature/orders/show/data/presentation/pages/order_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../models/order_model.dart';
import '../../../../../widgets/custom_alert.dart';

class OrdersSuccessView extends StatelessWidget {
  final List<Order> orders;
  final Future<void> Function()? onRefresh;

  const OrdersSuccessView({
    super.key,
    required this.orders,
    required this.onRefresh,
  });

  Color _getStatusColor(Order order) {
    if (order.isPaid) return Colors.green;
    if (order.isCancelled) return Colors.red;
    return Colors.orange;
  }

  String _formatTotal(double total) {
    final formatter = NumberFormat('#,##0', 'es_CO');
    return '\$${formatter.format(total)}';
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No tienes órdenes aún.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RefreshIndicator(
        color: Colors.black,
        onRefresh: onRefresh!,
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final statusColor = _getStatusColor(order);

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Borde lateral de estado
                    Container(
                      width: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                    // Contenido de la tarjeta
                    Expanded(
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OrderPage(orderId: order.id)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Orden #${order.orderNumber}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${order.itemsCount} ${order.itemsCount == 1 ? 'artículo' : 'artículos'}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatTotal(order.total),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      order.createdAt
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
