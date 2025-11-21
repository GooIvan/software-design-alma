import 'order_item_model.dart';

class Order {
  final int id;
  final String orderNumber;
  final String status;
  final String statusDisplay;
  final double total;
  final int itemsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem>? orderItems;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.statusDisplay,
    required this.total,
    required this.itemsCount,
    required this.createdAt,
    required this.updatedAt,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? 'pending',
      statusDisplay: json['status_display'] ?? json['status'] ?? 'Pending',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      itemsCount: json['items_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      orderItems: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'status_display': statusDisplay,
      'total': total,
      'items_count': itemsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (orderItems != null)
        'order_items': orderItems!.map((item) => item.toJson()).toList(),
    };
  }

  // Métodos de utilidad para estados
  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isCancelled => status == 'cancelled';

  // Formateo de precio
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  // Copia con modificaciones
  Order copyWith({
    int? id,
    String? orderNumber,
    String? status,
    String? statusDisplay,
    double? total,
    int? itemsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItem>? orderItems,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      statusDisplay: statusDisplay ?? this.statusDisplay,
      total: total ?? this.total,
      itemsCount: itemsCount ?? this.itemsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderItems: orderItems ?? this.orderItems,
    );
  }
}
