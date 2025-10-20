class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? size;
  final int quantity;
  final double price;
  final double totalPrice;
  final String? productImage;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.size,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    this.productImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? 'Producto sin nombre',
      size: json['size'],
      quantity: json['quantity'] ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      productImage: json['product_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'size': size,
      'quantity': quantity,
      'price': price,
      'total_price': totalPrice,
      'product_image': productImage,
    };
  }

  // Formateo de precios
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  // Información de talla
  String get sizeDisplay =>
      size?.isNotEmpty == true ? size! : 'Sin talla específica';

  // Copia con modificaciones
  OrderItem copyWith({
    int? id,
    int? productId,
    String? productName,
    String? size,
    int? quantity,
    double? price,
    double? totalPrice,
    String? productImage,
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      productImage: productImage ?? this.productImage,
    );
  }
}
