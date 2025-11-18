class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String formattedPrice;
  final List<String> sizes;
  final int stock;
  final int categoryId;
  final List<String> images;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.formattedPrice,
    required this.sizes,
    required this.stock,
    required this.categoryId,
    required this.images,
    required this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      formattedPrice: json['formatted_price'] ?? '',
      sizes:
          json['sizes'] != null ? List<String>.from(json['sizes']) : <String>[],
      stock: json['stock'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : <String>[],
      description: json['description'] ?? '',
    );
  }
}
