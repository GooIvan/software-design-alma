import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../widgets/custom_alert.dart';
import '../../../login/presentation/pages/login_page.dart';

class SocialRegisterSection extends StatelessWidget {
  const SocialRegisterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ===== Separador con "O" =====
        Row(
          children: [
            Expanded(
                child: Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("o",
                  style: TextStyle(
                      color: Theme.of(context).dividerColor, fontSize: 16)),
            ),
            Expanded(
                child: Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
            )),
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
          text: context.l10n.continueGoogle,
          color: Theme.of(context).scaffoldBackgroundColor,
          textColor:
              Theme.of(context).textTheme.displayLarge?.color ?? Colors.black,
          borderColor:
              Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
          context: context,
        ),

        const SizedBox(height: 12),

        // ===== Botón Apple =====
        /*
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
         */

        // ===== Botón Facebook =====
        // _buildSocialButton(
        //   icon: FontAwesomeIcons.facebook,
        //   text: context.l10n.continueFacebook,
        //   color: Theme.of(context).scaffoldBackgroundColor,
        //   textColor:
        //       Theme.of(context).textTheme.displayLarge?.color ?? Colors.black,
        //   borderColor:
        //       Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        //   context: context,
        // ),

        const SizedBox(height: 20),

        // ===== Link de registro =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.l10n.yesAccount,
                style: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge?.color ??
                      Colors.black,
                )),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text(
                context.l10n.login,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
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
          CustomAlert.warning(
            context,
            context.l10n.functionalityNotImplemented,
          );
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
