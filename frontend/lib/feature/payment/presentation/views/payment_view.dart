import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/payment_bloc.dart';
import '../../../orders/show/data/repositories/order_repository.dart';
import '../../../../models/order_model.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/payment_form_widget.dart';
import '../widgets/payment_button.dart';
import '../widgets/payment_status_widget.dart';
import '../widgets/note_sandbox.dart';
import '../controllers/payment_form_controller.dart';

class PaymentView extends StatefulWidget {
  final int orderId;

  const PaymentView({
    super.key,
    required this.orderId,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final OrderRepository _orderRepository = OrderRepository();
  final PaymentFormController _formController = PaymentFormController();

  Order? _order;
  bool _orderLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  Future<void> _loadOrder() async {
    try {
      final order = await _orderRepository.fetchOrder(widget.orderId);
      setState(() {
        _order = order;
        _orderLoading = false;
      });
    } catch (e) {
      setState(() {
        _orderLoading = false;
      });
    }
  }

  void _processPayment() {
    if (!_formController.validate()) {
      return;
    }

    final cardData = _formController.getCardData();

    // Disparar evento del BLoC
    context.read<PaymentBloc>().add(
          ProcessPayuPaymentEvent(
            orderId: widget.orderId,
            cardData: cardData,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_orderLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    if (_order == null) {
      return const Center(
        child: Text(
          'Error al cargar la orden',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen de la orden
          OrderSummaryCard(order: _order!),
          const SizedBox(height: 20),

          // Formulario de tarjeta
          PaymentFormWidget(controller: _formController),
          const SizedBox(height: 32),

          // Botón de pago
          PaymentButton(onPressed: _processPayment),
          const SizedBox(height: 20),

          // Estado del pago
          const PaymentStatusWidget(),
          const SizedBox(height: 20),

          // Nota de sandbox
          const NoteSandbox(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
