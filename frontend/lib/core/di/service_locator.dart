import '../../feature/home/data/repositories/home_repository.dart';
import '../../feature/home/data/bloc/product/product_bloc.dart';
import '../../feature/home/data/bloc/category/category_bloc.dart';
import '../../feature/cart/data/bloc/cart_bloc.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Singleton instances
  late final HomeRepository _homeRepository;
  late final CartBloc _cartBloc;

  // Initialize
  void initialize() {
    _homeRepository = HomeRepository();
    _cartBloc = CartBloc();
  }

  // Getters
  HomeRepository get homeRepository => _homeRepository;
  CartBloc get cartBloc => _cartBloc;

  // Factory methods for BLoCs
  ProductBloc createProductBloc() => ProductBloc(_homeRepository);
  CategoryBloc createCategoryBloc() => CategoryBloc(_homeRepository);
}

final sl = ServiceLocator();
