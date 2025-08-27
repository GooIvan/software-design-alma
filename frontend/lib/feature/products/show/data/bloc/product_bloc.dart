import 'package:design_alma/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final product =
            await repository.fetchProduct(event.categoryName, event.id);
        emit(ProductLoaded(product));
      } catch (e) {
        print('Error al cargar productos: $e');
        emit(const ProductError("Error al cargar productos"));
      }
    });

    on<RefreshProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final productos =
            await repository.fetchProduct(event.categoryName, event.id);
        emit(ProductLoaded(productos));
      } catch (e) {
        print('Error al refrescar productos: $e');
        emit(const ProductError("Error al refrescar productos"));
      }
    });
  }
}
