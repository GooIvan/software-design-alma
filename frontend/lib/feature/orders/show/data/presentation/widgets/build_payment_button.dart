import 'package:flutter/material.dart';
import '../../../../../payment/presentation/pages/payment_page.dart';

Widget buildPaymentButton(BuildContext context, int orderId) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.2),
          spreadRadius: 0,
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: () {
        // Navegar a la página de pago
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentPage(orderId: orderId),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Realizar el pago',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
