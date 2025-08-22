class CartItem {
  final String id;
  final int productId;
  final String productName;
  final String productImageUrl;
  final String categoryName;
  final double price;
  final String formattedPrice;
  final String size;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.categoryName,
    required this.price,
    required this.formattedPrice,
    required this.size,
    required this.quantity,
  });

  CartItem copyWith({
    String? id,
    int? productId,
    String? productName,
    String? productImageUrl,
    String? categoryName,
    double? price,
    String? formattedPrice,
    String? size,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      categoryName: categoryName ?? this.categoryName,
      price: price ?? this.price,
      formattedPrice: formattedPrice ?? this.formattedPrice,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image_url': productImageUrl,
      'category_name': categoryName,
      'price': price,
      'formatted_price': formattedPrice,
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      productId: json['product_id'],
      productName: json['product_name'],
      productImageUrl: json['product_image_url'],
      categoryName: json['category_name'],
      price: double.parse(json['price'].toString()),
      formattedPrice: json['formatted_price'],
      size: json['size'],
      quantity: json['quantity'],
    );
  }

  double get totalPrice => price * quantity;
}
