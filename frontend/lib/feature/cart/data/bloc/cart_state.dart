part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isLoading;

  const CartState({
    this.items = const [],
    this.isLoading = false,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // Getters útiles
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  String get formattedTotalPrice {
    final formatter = NumberFormat('#,###', 'es_CO'); // puntos de miles
    return '\$${formatter.format(totalPrice)}'; // símbolo siempre antes
  }

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object> get props => [items, isLoading];
}
