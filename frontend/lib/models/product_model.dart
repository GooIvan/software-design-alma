class Product {
  final int id;
  final String name;
  final double price;
  final String formattedPrice;
  final List<String> sizes;
  final int stock;
  final int categoryId;
  final String imageUrl;
  final String categoryName;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.formattedPrice,
    required this.sizes,
    required this.stock,
    required this.categoryId,
    required this.imageUrl,
    required this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']),
      formattedPrice: json['formatted_price'],
      sizes: List<String>.from(json['sizes']),
      stock: json['stock'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      imageUrl: json['image_url'],
    );
  }
}
