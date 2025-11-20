import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              "Términos y Condiciones",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Esta aplicación de ecommerce utiliza tus datos únicamente para "
              "gestionar pedidos, crear tu cuenta, permitir pagos y mejorar la "
              "experiencia de compra.\n\n"
              "Información recopilada:\n"
              "- Nombre y datos de contacto\n"
              "- Dirección para envíos\n"
              "- Historial de órdenes\n\n"
              "Uso de la información:\n"
              "- Procesamiento de compras\n"
              "- Soporte al cliente\n"
              "- Envíos y notificaciones\n\n"
              "No compartimos tu información con terceros excepto servicios "
              "necesarios como pasarelas de pago o envíos.\n\n"
              "Al registrarte o iniciar sesión, aceptas estos términos.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
