import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/custom_alert.dart';
import '../../data/bloc/payment_bloc.dart';
import '../../data/repositories/payment_repository.dart';
import '../views/payment_view.dart';

class PaymentPage extends StatelessWidget {
  final int orderId;

  const PaymentPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(
        paymentRepository: PaymentRepository(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Procesar Pago',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[50],
        body: BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              CustomAlert.success(context, state.message);
              // Navegar de vuelta
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state is PaymentError) {
              CustomAlert.error(context, state.message);
            } else if (state is PaymentStatusLoaded) {
              CustomAlert.success(context, state.message);
            } else if (state is PaymentStatusError) {
              CustomAlert.warning(context, state.message);
            }
          },
          child: PaymentView(orderId: orderId),
        ),
      ),
    );
  }
}
