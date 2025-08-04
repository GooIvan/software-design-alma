import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_model.dart';
import '../repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeLoading()) {
    on<LoadHome>((event, emit) async {
      emit(HomeLoading());
      try {
        final products = await repository.fetchProducts();
        final categories = await repository.fetchCategories();
        emit(HomeLoaded(products, categories));
      } catch (e) {
        print('Error al cargar incio: $e');
        emit(const HomeError("Error al cargar inicio"));
      }
    });
  }
}
