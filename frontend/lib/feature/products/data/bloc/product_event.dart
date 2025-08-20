part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final String categoryName;

  const LoadProducts(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
}

class RefreshProducts extends ProductEvent {
  final String categoryName;

  const RefreshProducts(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
}
