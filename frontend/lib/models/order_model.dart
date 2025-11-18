import 'order_item_model.dart';
import 'package:intl/intl.dart';

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
  final String? discountCode;
  final double? discountAmount;
  final double? subtotal;

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
    this.discountCode,
    this.discountAmount,
    this.subtotal,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parsear información del descuento desde el objeto anidado
    String? discountCode;
    double? discountAmount;
    double? subtotal;

    if (json['discount'] != null) {
      final discount = json['discount'];
      discountCode = discount['code'];
      discountAmount = discount['amount'] != null
          ? double.tryParse(discount['amount'].toString())
          : null;
    }

    subtotal = json['subtotal'] != null
        ? double.tryParse(json['subtotal'].toString())
        : null;

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
      discountCode: discountCode,
      discountAmount: discountAmount,
      subtotal: subtotal,
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
      if (discountCode != null) 'discount_code': discountCode,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (subtotal != null) 'subtotal': subtotal,
    };
  }

  // Métodos de utilidad para estados
  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isCancelled => status == 'cancelled';
  bool get hasDiscount => discountCode != null && discountAmount != null;

  // Formateo de precio
    String get formattedTotal => _currencyFormat.format(total);
    String get formattedSubtotal =>
      subtotal != null ? _currencyFormat.format(subtotal) : formattedTotal;
    String get formattedDiscountAmount => discountAmount != null
      ? _currencyFormat.format(discountAmount)
      : _currencyFormat.format(0);

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
    String? discountCode,
    double? discountAmount,
    double? subtotal,
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
      discountCode: discountCode ?? this.discountCode,
      discountAmount: discountAmount ?? this.discountAmount,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}

// Formateador de moneda con separador de miles en punto y coma decimal (locale español)
final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$');
