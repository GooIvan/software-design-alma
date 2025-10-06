part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class LoadOrder extends OrderEvent {
  final int id;

  const LoadOrder(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshOrder extends OrderEvent {
  final int id;

  const RefreshOrder(this.id);

  @override
  List<Object> get props => [id];
}
