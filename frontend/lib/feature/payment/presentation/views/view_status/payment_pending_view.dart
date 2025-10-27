import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';

class PaymentPendingView extends StatelessWidget {
  const PaymentPendingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ===== Ícono de pendiente =====
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECB3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB300),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ===== Mensaje principal =====
              Text(
                context.l10n.pendingPayment,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFB300),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ===== Subtítulo =====
              Text(
                "${context.l10n.pendingPaymentMessage1}\n"
                "${context.l10n.pendingPaymentMessage2}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF808080),
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              // ===== Botón =====
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/main', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    context.l10n.understand,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
