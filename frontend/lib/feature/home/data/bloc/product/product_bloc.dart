import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../models/product_model.dart';
import '../../repositories/home_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final HomeRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        print('Error al cargar productos: $e');
        emit(const ProductError("Error al cargar productos"));
      }
    });

    on<RefreshProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        // Usar el método refresh que ignora el caché
        final products = await repository.refreshProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        print('Error al refrescar productos: $e');
        emit(const ProductError("Error al refrescar productos"));
      }
    });
  }
}
