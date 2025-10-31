import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../models/order_item_model.dart';

String _formatPrice(double price) {
  final formatter = NumberFormat('#,##0');
  return '\$${formatter.format(price)}';
}

Widget buildOrderItem(OrderItem item, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        )),
    child: Row(
      children: [
        // Imagen del producto
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.productImage != null
              ? Image.network(
                  item.productImage!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    );
                  },
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_bag,
                    color: Colors.grey[400],
                    size: 40,
                  ),
                ),
        ),
        const SizedBox(width: 16),
        // Información del producto
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (item.size != null) ...[
                Text(
                  '${context.l10n.size}: ${item.size}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                '${context.l10n.quantity}: ${item.quantity}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${context.l10n.priceUnit}: ${_formatPrice(item.price)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Precio total del item
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatPrice(item.totalPrice),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).textTheme.displayLarge?.color,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
