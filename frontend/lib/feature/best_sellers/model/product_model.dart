
class Product {
  final String name;
  final double price;
  final String image;

  Product({required this.name, required this.price, required this.image});

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(
        name: json['name'],
        price: (json['price'] as num).toDouble(),
        image: json['image'],
      );
}
