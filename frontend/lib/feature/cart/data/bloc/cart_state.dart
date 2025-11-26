part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final bool isLoading;
  final DiscountCode? appliedDiscountCode;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.appliedDiscountCode,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    DiscountCode? appliedDiscountCode,
    bool clearDiscount = false,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      appliedDiscountCode: clearDiscount
          ? null
          : (appliedDiscountCode ?? this.appliedDiscountCode),
    );
  }

  // Getters útiles
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount {
    if (appliedDiscountCode == null) return 0.0;
    return appliedDiscountCode!.calculateDiscount(totalPrice);
  }

  double get finalTotal {
    final total = totalPrice - discountAmount;
    return total > 0 ? total : 0;
  }

  String get formattedTotalPrice {
    final formatter = NumberFormat('#,###', 'es_CO'); // puntos de miles
    return '\$${formatter.format(totalPrice)}'; // símbolo siempre antes
  }

  String get formattedFinalTotal {
    final formatter = NumberFormat('#,###', 'es_CO');
    return '\$${formatter.format(finalTotal)}';
  }

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  bool get hasDiscount => appliedDiscountCode != null;

  @override
  List<Object> get props => [items, isLoading, appliedDiscountCode ?? 'null'];
}
