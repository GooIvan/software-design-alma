import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/order_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final Order order;

  const OrderSummaryCard({super.key, required this.order});

  String _formatTotal(double total) {
    final formatter = NumberFormat('#,##0', 'es_CO');
    return '\$${formatter.format(total)}';
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isStatus = false, String? status}) {
    Color? statusColor;
    if (isStatus && status != null) {
      if (status.toLowerCase() == 'paid')
        statusColor = Colors.green;
      else if (status.toLowerCase() == 'cancelled')
        statusColor = Colors.red;
      else
        statusColor = Colors.orange;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isStatus
                ? statusColor
                : Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  context.l10n.sumaryOrder,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(context, context.l10n.order, '#${order.id}'),
            const SizedBox(height: 8),
            _buildSummaryRow(
                context, context.l10n.total, _formatTotal(order.total)),
            const SizedBox(height: 8),
            _buildSummaryRow(context, context.l10n.state, order.status,
                isStatus: true, status: order.status),
          ],
        ),
      ),
    );
  }
}
