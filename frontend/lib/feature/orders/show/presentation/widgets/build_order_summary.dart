import 'package:design_alma/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../../../models/order_model.dart';

String _formatPrice(double price) {
  final formatter = NumberFormat('#,##0');
  return '\$${formatter.format(price)}';
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
      ],
    ),
  );
}
