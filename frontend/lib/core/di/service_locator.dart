import '../../feature/home/data/repositories/home_repository.dart';
import '../../feature/home/data/bloc/product/product_bloc.dart';
import '../../feature/home/data/bloc/category/category_bloc.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Singleton instances
  late final HomeRepository _homeRepository;

  // Initialize
  void initialize() {
    _homeRepository = HomeRepository();
  }

  // Getters
  HomeRepository get homeRepository => _homeRepository;

  // Factory methods for BLoCs
  ProductBloc createProductBloc() => ProductBloc(_homeRepository);
  CategoryBloc createCategoryBloc() => CategoryBloc(_homeRepository);
}

final sl = ServiceLocator();
