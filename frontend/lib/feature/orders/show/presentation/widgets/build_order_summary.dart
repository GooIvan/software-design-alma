import 'package:design_alma/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../../../models/order_model.dart';

String _formatPrice(double price) {
  final formatter = NumberFormat('#,##0');
  return '\$${formatter.format(price)}';
}

double _calculateSubtotal(Order order) {
  // Si hay subtotal disponible, usarlo
  if (order.subtotal != null) {
    return order.subtotal!;
  }

  // Si hay order items, calcular directamente
  if (order.orderItems != null && order.orderItems!.isNotEmpty) {
    return order.orderItems!.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Si hay descuento, calcular subtotal original
  if (order.discountAmount != null && order.discountAmount! > 0) {
    return order.total + order.discountAmount!;
  }

  // Si no hay descuento, el subtotal es igual al total
  return order.total;
}

Widget buildOrderSummary(Order order, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        )),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.sumaryOrder,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.l10n.totalArticles}:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            Text(
              '${order.orderItems?.length ?? 0} ${(order.orderItems?.length ?? 0) == 1 ? context.l10n.article : context.l10n.articles}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
        const SizedBox(height: 12),

        // Mostrar información de precios con o sin descuento
        ..._buildPricingInfo(order, context),
      ],
    ),
  );
}

List<Widget> _buildPricingInfo(Order order, BuildContext context) {
  final hasDiscount = order.discountCode != null &&
      order.discountCode!.isNotEmpty &&
      (order.discountAmount ?? 0.0) > 0;

  if (hasDiscount) {
    final subtotal = _calculateSubtotal(order);

    return [
      // Subtotal
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${context.l10n.subtotalBeforeDiscount}:',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            _formatPrice(subtotal),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      const SizedBox(height: 8),

      // Descuento
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${context.l10n.discount} (${order.discountCode}):',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[700],
            ),
          ),
          Text(
            '-${_formatPrice(order.discountAmount!)}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // Línea divisoria para el total
      Divider(
        color: Theme.of(context).dividerColor.withOpacity(0.5),
      ),
      const SizedBox(height: 8),

      // Total final
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${context.l10n.total}:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            _formatPrice(order.total - (order.discountAmount ?? 0.0)),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
        ],
      ),
    ];
  } else {
    // Sin descuento, solo mostrar el total
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${context.l10n.total}:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            _formatPrice(order.total),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
        ],
      ),
    ];
  }
}
