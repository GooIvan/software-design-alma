part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class ProcessPayuPaymentEvent extends PaymentEvent {
  final int orderId;
  final CardData cardData;

  const ProcessPayuPaymentEvent({
    required this.orderId,
    required this.cardData,
  });

  @override
  List<Object?> get props => [orderId, cardData];
}

class GetPaymentStatusEvent extends PaymentEvent {
  final int orderId;

  const GetPaymentStatusEvent({
    required this.orderId,
  });

  @override
  List<Object?> get props => [orderId];
}
