import 'package:flutter/material.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({Key? key}) : super(key: key);

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

              // ===== Ícono de éxito =====
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F9F1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCFF5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34C759),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ===== Mensaje principal =====
              const Text(
                '¡Pedido realizado\nexitosamente!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF34C759),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ===== Subtítulo =====
              const Text(
                "Ha realizado su pedido con éxito,\n"
                "Recibirás tu recibo muy pronto.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF808080),
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              // ===== Botón inferior =====
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/main', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'DE ACUERDO',
                    style: TextStyle(
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
