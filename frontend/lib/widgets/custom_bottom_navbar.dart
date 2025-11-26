import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 12, // 👈 esto crea el efecto flotante
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            /// Inicio
            SalomonBottomBarItem(
              icon: const Icon(FeatherIcons.home),
              title: Text(context.l10n.home),
              selectedColor: Colors.blue,
            ),

            /// Categorías
            SalomonBottomBarItem(
              icon: const Icon(FeatherIcons.grid),
              title: Text(context.l10n.categories),
              selectedColor: Colors.blue,
            ),

            /// Favoritos
            SalomonBottomBarItem(
              icon: const Icon(FeatherIcons.heart),
              title: Text(context.l10n.favorites),
              selectedColor: Colors.red,
            ),

            /// Perfil
            SalomonBottomBarItem(
              icon: const Icon(FeatherIcons.user),
              title: Text(context.l10n.profile),
              selectedColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
