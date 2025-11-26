part of 'admin_products_bloc.dart';

abstract class AdminProductsEvent extends Equatable {
  const AdminProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminProducts extends AdminProductsEvent {}

class RefreshAdminProducts extends AdminProductsEvent {}
