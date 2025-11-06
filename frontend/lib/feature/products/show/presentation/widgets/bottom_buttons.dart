import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback handleBuyNow;
  final VoidCallback handleAddCart;

  const BottomButtons(
      {super.key, required this.handleBuyNow, required this.handleAddCart});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            // Comprar ahora
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  elevation: 0,
                ),
                onPressed: handleBuyNow,
                icon: const Icon(
                  FeatherIcons.shoppingBag,
                  color: Colors.white,
                  size: 22,
                ),
                label: Text(
                  context.l10n.buyNow,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Añadir a la cesta
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F0FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                ),
                onPressed: handleAddCart,
                icon: const Icon(
                  FeatherIcons.plusCircle,
                  color: Color(0xFF1E90FF),
                  size: 22,
                ),
                label: Text(
                  context.l10n.addToCart,
                  style: const TextStyle(
                    color: Color(0xFF1E90FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
