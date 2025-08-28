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
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              "Tu lista de favoritos está vacía",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Descripción
            Text(
              "Agrega productos a favoritos para verlos aquí.",
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
