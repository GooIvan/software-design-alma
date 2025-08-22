part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;
  final String size;
  final int quantity;

  const AddToCart({
    required this.product,
    required this.size,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [product, size, quantity];
}

class RemoveFromCart extends CartEvent {
  final String itemId;

  const RemoveFromCart(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class UpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateQuantity({
    required this.itemId,
    required this.quantity,
  });

  @override
  List<Object> get props => [itemId, quantity];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class LoadCart extends CartEvent {
  const LoadCart();
}
