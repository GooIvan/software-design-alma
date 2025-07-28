import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../models/categories_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadCategories>(_onLoadLatestProducts);
  }

  Future<void> _onLoadLatestProducts(
      LoadCategories event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      // Simula una carga desde una API o base de datos
      await Future.delayed(const Duration(seconds: 2));
      final categories = [
        Categories(name: "Camisetas", description: "Tallas: M L", precio: 32.000),
        Categories(name: "Tazas", description: "De Losa", precio: 15.000),
      ];

      emit(HomeLoaded(categories));
    } catch (e) {
      emit(HomeError("No se pudieron cargar los productos"));
    }
  }
}
