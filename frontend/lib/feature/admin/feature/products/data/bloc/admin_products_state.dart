part of 'admin_products_bloc.dart';

abstract class AdminProductsState extends Equatable {
  const AdminProductsState();

  @override
  List<Object> get props => [];
}

class AdminProductsInitial extends AdminProductsState {}

class AdminProductsLoading extends AdminProductsState {}

class AdminProductsLoaded extends AdminProductsState {
  final DashboardModel products;
  const AdminProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class AdminProductsError extends AdminProductsState {
  final String message;

  const AdminProductsError(this.message);

  @override
  List<Object> get props => [message];
}
