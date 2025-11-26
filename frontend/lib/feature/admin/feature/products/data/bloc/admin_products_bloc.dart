import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/admin_products.dart';
import '../../../../models/dashboard_model.dart';

part 'admin_products_event.dart';
part 'admin_products_state.dart';

class AdminProductsBloc extends Bloc<AdminProductsEvent, AdminProductsState> {
  final AdminProductsRepository repository;
  AdminProductsBloc(this.repository) : super(AdminProductsInitial()) {
    on<LoadAdminProducts>((event, emit) async {
      emit(AdminProductsLoading());
      try {
        final products = await repository.fetchAdminProducts();
        emit(AdminProductsLoaded(products));
      } catch (e) {
        print('Error al cargar los productos de admin: $e');
        emit(
            const AdminProductsError("Error al cargar los productos de admin"));
      }
    });

    on<RefreshAdminProducts>((event, emit) async {
      emit(AdminProductsLoading());
      try {
        final products = await repository.fetchAdminProducts();
        emit(AdminProductsLoaded(products));
      } catch (e) {
        print('Error al refrescar los productos de admin: $e');
        emit(const AdminProductsError(
            "Error al refrescar los productos de admin"));
      }
    });
  }
}
