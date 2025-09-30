import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../widgets/custom_alert.dart';
import '../../../register/presentation/pages/register_page.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ===== Separador con "O" =====
        const Row(
          children: [
            Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("o",
                  style: TextStyle(color: Colors.black54, fontSize: 16)),
            ),
            Expanded(child: Divider(thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),

        // ===== Botón Google =====
        _buildSocialButton(
          imageIcon: Image.asset(
            'assets/icon_google.png',
            height: 20,
            width: 20,
          ),
          text: "Continuar con Google",
          color: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          context: context,
        ),

        const SizedBox(height: 12),

        // ===== Botón Apple =====
        _buildSocialButton(
          icon: FontAwesomeIcons.apple,
          text: "Continuar con Apple",
          color: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          colorIcon: Colors.black,
          context: context,
        ),

        const SizedBox(height: 12),

        // ===== Botón Facebook =====
        _buildSocialButton(
          icon: FontAwesomeIcons.facebook,
          text: "Continuar con Facebook",
          color: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          colorIcon: const Color(0xFF1877F2),
          context: context,
        ),

        const SizedBox(height: 20),

        // ===== Link de registro =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("¿No tienes cuenta?",
                style: TextStyle(
                  color: Colors.black,
                )),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text(
                "Regístrate",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    IconData? icon, // opcional
    Widget? imageIcon, // opcional (para logos personalizados)
    required String text,
    required Color color,
    required Color textColor,
    required Color borderColor,
    Color? colorIcon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          CustomAlert.warning(context, 'Funcionalidad en desarrollo');
        },
        icon: imageIcon ??
            FaIcon(
              icon,
              color: colorIcon ?? textColor,
              size: 20,
            ),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: borderColor),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
