import 'product_model.dart';

class Favorite {
  final int id;
  final int userId;
  final Product product;

  Favorite({
    required this.id,
    required this.userId,
    required this.product,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      userId: json['user_id'],
      product: Product.fromJson(json['product']),
    );
  }
}
