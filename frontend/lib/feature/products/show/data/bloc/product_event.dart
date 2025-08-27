part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProduct extends ProductEvent {
  final String categoryName;
  final int id;

  const LoadProduct(this.categoryName, this.id);

  @override
  List<Object?> get props => [categoryName, id];
}

class RefreshProduct extends ProductEvent {
  final String categoryName;
  final int id;

  const RefreshProduct(this.categoryName, this.id);

  @override
  List<Object?> get props => [categoryName, id];
}
