import 'package:design_alma/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/product_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository repository;

  ProductsBloc(this.repository) : super(ProductsInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductsLoading());
      try {
        final productos = await repository.fetchProducts(event.categoryName);
        emit(ProductsLoaded(productos));
      } catch (e) {
        print('Error al cargar productos: $e');
        emit(const ProductsError("Error al cargar productos"));
      }
    });

    on<RefreshProducts>((event, emit) async {
      emit(ProductsLoading());
      try {
        final productos = await repository.fetchProducts(event.categoryName);
        emit(ProductsLoaded(productos));
      } catch (e) {
        print('Error al refrescar productos: $e');
        emit(const ProductsError("Error al refrescar productos"));
      }
    });
  }
}
