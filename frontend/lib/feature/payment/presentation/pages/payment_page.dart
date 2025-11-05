import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/payment_bloc.dart';
import '../../data/repositories/payment_repository.dart';
import '../views/view_status/payment_error_view.dart';
import '../views/view_status/payment_success_view.dart';
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
          if (state is PaymentSuccess) {
            return const PaymentSuccessView();
          } else if (state is PaymentError) {
            return const PaymentErrorView();
          } else {
            return PaymentView(orderId: orderId);
          }
        }),
      ),
    );
  }
}
