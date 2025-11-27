import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../../../../models/order_model.dart';
import '../widgets/build_order_header.dart';
import '../widgets/build_order_item.dart';
import '../widgets/build_order_summary.dart';
import '../widgets/build_payment_button.dart';

class OrderSuccessView extends StatelessWidget {
  final Order order;
  final Future<void> Function()? onRefresh;

  const OrderSuccessView({
    super.key,
    required this.order,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).textTheme.displayLarge?.color,
      onRefresh: onRefresh!,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de la orden
              buildOrderHeader(order, context),
              const SizedBox(height: 20),

              // Título de artículos
              Text(
                context.l10n.articles,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),

              // Lista de items
              if (order.orderItems != null && order.orderItems!.isNotEmpty)
                ...order.orderItems!
                    .map((item) => buildOrderItem(item, context))
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      context.l10n.noArticles,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Resumen de la orden
              buildOrderSummary(order, context),

              const SizedBox(height: 20),

              // Botón de pago (solo para órdenes pendientes)
              if (order.isPending) buildPaymentButton(context, order.id),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
