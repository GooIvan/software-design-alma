import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/order_repository.dart';
import '../../../../../models/order_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc(this.repository) : super(OrderInitial()) {
    on<LoadOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        final order = await repository.fetchOrder(event.id);
        emit(OrderLoaded(order));
      } catch (e) {
        print('Error al cargar las ordenes: $e');
        emit(const OrderError("Error al cargar las ordenes"));
      }
    });

    on<RefreshOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await repository.fetchOrder(event.id);
        emit(OrderLoaded(orders));
      } catch (e) {
        print('Error al refrescar las ordenes: $e');
        emit(const OrderError("Error al refrescar las ordenes"));
      }
    });
  }
}
