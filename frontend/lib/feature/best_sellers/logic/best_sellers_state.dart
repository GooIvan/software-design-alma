
import 'package:equatable/equatable.dart';
import '../model/product_model.dart';

abstract class BestSellersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BestSellersInitial extends BestSellersState {}
class BestSellersLoading extends BestSellersState {}
class BestSellersLoaded extends BestSellersState {
  final List<Product> products;
  BestSellersLoaded(this.products);

  @override
  List<Object?> get props => [products];
}
class BestSellersError extends BestSellersState {
  final String message;
  BestSellersError(this.message);

  @override
  List<Object?> get props => [message];
}
