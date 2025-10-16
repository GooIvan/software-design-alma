import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';

class EmptyFavoritesPage extends StatelessWidget {
  const EmptyFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono de favoritos vacío
            // Ícono con sombra y animación de rebote
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[200]!, Colors.grey[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_border,
                  size: 70,
                  color: Colors.grey[400],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Título
            Text(
              context.l10n.noFavorites,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Descripción
            Text(
              context.l10n.messageNoFavorites,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
