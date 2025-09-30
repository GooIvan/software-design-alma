// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../models/cart_item_model.dart';
import '../../../../models/product_model.dart';
import 'package:intl/intl.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);

    // Buscar si ya existe el mismo producto con la misma talla
    final existingIndex = items.indexWhere(
      (item) => item.productId == event.product.id && item.size == event.size,
    );

    if (existingIndex != -1) {
      // Si existe, actualizar cantidad
      final existingItem = items[existingIndex];
      items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      // Si no existe, crear nuevo item
      final newItem = CartItem(
        id: '${event.product.id}_${event.size}_${DateTime.now().millisecondsSinceEpoch}',
        productId: event.product.id,
        productName: event.product.name,
        productImageUrl: event.product.imageUrl,
        categoryName: event.product.categoryName,
        price: event.product.price,
        formattedPrice: event.product.formattedPrice,
        size: event.size,
        quantity: event.quantity,
      );
      items.add(newItem);
    }

    emit(state.copyWith(items: items));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    items.removeWhere((item) => item.id == event.itemId);
    emit(state.copyWith(items: items));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((item) => item.id == event.itemId);

    if (index != -1) {
      if (event.quantity > 0) {
        items[index] = items[index].copyWith(quantity: event.quantity);
      } else {
        items.removeAt(index);
      }
      emit(state.copyWith(items: items));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    // Aquí podrías cargar el carrito desde storage o API
    // Por ahora solo emitimos el estado actual
    emit(state);
  }

  @override
  void emit(CartState state) {
    print('CartBloc emitted state: totalItems=${state.totalItems}');
    super.emit(state);
  }
}
