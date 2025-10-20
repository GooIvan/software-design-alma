import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/payment_repository.dart';
import '../../../../models/payment_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc({
    required PaymentRepository paymentRepository,
  })  : _paymentRepository = paymentRepository,
        super(PaymentInitial()) {
    on<ProcessPayuPaymentEvent>(_onProcessPayuPayment);
    on<GetPaymentStatusEvent>(_onGetPaymentStatus);
  }

  Future<void> _onProcessPayuPayment(
    ProcessPayuPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());

    try {
      // Verificar que la orden existe primero
      final orderExists =
          await _paymentRepository.verifyOrderExists(event.orderId);
      if (!orderExists) {
        emit(const PaymentError(
          message:
              'La orden no existe o no tienes permisos para acceder a ella',
        ));
        return;
      }

      // Procesar el pago
      final result = await _paymentRepository.processPayuPayment(
        orderId: event.orderId,
        cardData: event.cardData,
      );

      if (result.success) {
        emit(PaymentSuccess(
          message: result.message,
          paymentResponse: result,
        ));
      } else {
        emit(PaymentError(
          message: result.message,
        ));
      }
    } catch (e) {
      emit(PaymentError(
        message: 'Error inesperado: $e',
      ));
    }
  }

  Future<void> _onGetPaymentStatus(
    GetPaymentStatusEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentStatusLoading());

    try {
      final result = await _paymentRepository.getPaymentStatus(
        orderId: event.orderId,
      );

      if (result.success) {
        emit(PaymentStatusLoaded(
          message: result.message,
          statusResponse: result,
        ));
      } else {
        emit(PaymentStatusError(
          message: result.message,
        ));
      }
    } catch (e) {
      emit(PaymentStatusError(
        message: 'Error inesperado: $e',
      ));
    }
  }
}
