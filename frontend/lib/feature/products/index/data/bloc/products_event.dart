part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {
  final String categoryName;

  const LoadProducts(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
}

class RefreshProducts extends ProductsEvent {
  final String categoryName;

  const RefreshProducts(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
}
