import 'package:flutter/material.dart';
import '../../../../../../models/order_model.dart';

Color _getStatusColor(Order order) {
  if (order.isPaid) return Colors.green;
  if (order.isCancelled) return Colors.red;
  return Colors.orange;
}

Widget buildStatusChip(Order order) {
  final statusColor = _getStatusColor(order);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: statusColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: statusColor, width: 1),
    ),
    child: Text(
      order.statusDisplay,
      style: TextStyle(
        color: statusColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}

String _formatDate(DateTime date) {
  final localDate = date.toLocal();
  final day = localDate.day.toString().padLeft(2, '0');
  final month = localDate.month.toString().padLeft(2, '0');
  final year = localDate.year.toString();
  final hour = localDate.hour.toString().padLeft(2, '0');
  final minute = localDate.minute.toString().padLeft(2, '0');

  return '$day/$month/$year $hour:$minute';
}

Widget buildOrderHeader(Order order) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Orden #${order.orderNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            buildStatusChip(order),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Creada: ${_formatDate(order.createdAt)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.update, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Actualizada: ${_formatDate(order.updatedAt)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
