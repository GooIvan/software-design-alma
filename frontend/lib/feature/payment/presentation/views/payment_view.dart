import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/payment_bloc.dart';
import '../../../orders/show/data/repositories/order_repository.dart';
import '../../../../models/order_model.dart';
import '../../../../models/discount_code_model.dart';
import '../../../../widgets/discount_code_widget.dart';
import '../../../../widgets/order_summary_with_discount_card.dart';
import '../widgets/payment_form_widget.dart';
import '../widgets/payment_button.dart';
import '../widgets/payment_status_widget.dart';
import '../widgets/note_sandbox.dart';
import '../controllers/payment_form_controller.dart';
import 'payment_loading_view.dart';

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
  DiscountCode? _appliedDiscount;
  double? _discountedTotal;

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
        // Si la orden tiene un descuento aplicado, lo establecemos automáticamente
        if (order.hasDiscount) {
          _appliedDiscount = DiscountCode(
            code: order.discountCode!,
            discountType:
                'fixed_amount', // Asumimos que es monto fijo ya que tenemos el monto exacto
            value: order.discountAmount!,
            description: context.l10n.discountDescription(order.discountCode!),
            discountAmount: order.discountAmount!,
          );
          _discountedTotal = order.total;
        }
      });
    } catch (e) {
      setState(() {
        _orderLoading = false;
      });
    }
  }

  void _onDiscountApplied(DiscountCode? discount) {
    setState(() {
      _appliedDiscount = discount;
      if (discount != null && _order != null) {
        _discountedTotal = discount.calculateDiscountedTotal(_order!.total);
      } else {
        _discountedTotal = null;
      }
    });
  }

  void _onDiscountRemoved() {
    setState(() {
      _appliedDiscount = null;
      _discountedTotal = null;
    });
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
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
          elevation: 0,
        ),
        body: const Center(
          child: PaymentLoadingView(),
        ),
      );
    }

    if (_order == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
          elevation: 0,
        ),
        body: Center(
          child: Text(
            context.l10n.errorPayment,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.displayLarge?.color,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de la orden con descuento
            OrderSummaryWithDiscountCard(
              order: _order!,
              appliedDiscount: _appliedDiscount,
              discountedTotal: _discountedTotal,
            ),
            const SizedBox(height: 20),

            // Widget de código de descuento - solo si la orden no tiene descuento aplicado
            if (!(_order!.hasDiscount))
              Column(
                children: [
                  DiscountCodeWidget(
                    onDiscountApplied: _onDiscountApplied,
                    onDiscountRemoved: _onDiscountRemoved,
                    subtotal: _order!.subtotal ?? _order!.total,
                    currentDiscount: _appliedDiscount,
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Si la orden ya tiene descuento, mostrar información del descuento aplicado
            if (_order!.hasDiscount)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.discountApplied,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            context.l10n
                                .discountCodeLabel(_order!.discountCode!),
                            style: TextStyle(color: Colors.green.shade600),
                          ),
                          Text(
                            context.l10n
                                .discountValue(_order!.formattedDiscountAmount),
                            style: TextStyle(color: Colors.green.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            if (_order!.hasDiscount) const SizedBox(height: 20),

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
      ),
    );
  }
}
