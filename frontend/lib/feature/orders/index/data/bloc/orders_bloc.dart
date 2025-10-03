import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/orders_repository.dart';
import '../../../../../models/order_model.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository repository;

  OrdersBloc(this.repository) : super(OrdersInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final orders = await repository.fetchOrders();
        emit(OrdersLoaded(orders));
      } catch (e) {
        print('Error al cargar las ordenes: $e');
        emit(const OrdersError("Error al cargar las ordenes"));
      }
    });

    on<RefreshOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final orders = await repository.fetchOrders();
        emit(OrdersLoaded(orders));
      } catch (e) {
        print('Error al refrescar las ordenes: $e');
        emit(const OrdersError("Error al refrescar las ordenes"));
      }
    });
  }
}
