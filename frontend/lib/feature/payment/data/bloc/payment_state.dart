part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String message;
  final PaymentResponse paymentResponse;

  const PaymentSuccess({
    required this.message,
    required this.paymentResponse,
  });

  @override
  List<Object?> get props => [message, paymentResponse];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

// Estados para consulta de status
class PaymentStatusLoading extends PaymentState {}

class PaymentStatusLoaded extends PaymentState {
  final String message;
  final PaymentStatusResponse statusResponse;

  const PaymentStatusLoaded({
    required this.message,
    required this.statusResponse,
  });

  @override
  List<Object?> get props => [message, statusResponse];

  @override
  String toString() => 'PaymentStatusLoaded { message: $message }';
}

class PaymentStatusError extends PaymentState {
  final String message;

  const PaymentStatusError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
