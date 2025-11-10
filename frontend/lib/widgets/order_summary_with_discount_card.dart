import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../../../models/order_model.dart';
import '../../../../models/discount_code_model.dart';

class OrderSummaryWithDiscountCard extends StatelessWidget {
  final Order order;
  final DiscountCode? appliedDiscount;
  final double? discountedTotal;

  const OrderSummaryWithDiscountCard({
    super.key,
    required this.order,
    this.appliedDiscount,
    this.discountedTotal,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = appliedDiscount != null;
    final discount =
        hasDiscount ? appliedDiscount!.calculateDiscount(order.total) : 0.0;
    final finalTotal =
        hasDiscount ? (discountedTotal ?? order.total - discount) : order.total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${context.l10n.sumaryOrder} #${order.id}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Items de la orden
            ...(order.orderItems ?? []).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${item.productName} x ${item.quantity}'),
                      ),
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),

            const Divider(),

            // Subtotal
            Row(
              children: [
                Expanded(
                    child: Text('${context.l10n.subtotalBeforeDiscount}:')),
                Text(
                  '\$${order.total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            // Descuento (si aplica)
            if (hasDiscount) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.local_offer,
                            size: 16, color: Colors.green.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${context.l10n.discountAmount} (${appliedDiscount!.code}):',
                          style: TextStyle(color: Colors.green.shade600),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '-\$${discount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],

            const Divider(),

            // Total final
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${context.l10n.total}:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  '\$${finalTotal.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: hasDiscount ? Colors.green.shade700 : null,
                      ),
                ),
              ],
            ),

            // Ahorro (si hay descuento)
            if (hasDiscount && discount > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  '${context.l10n.youSave} \$${discount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
