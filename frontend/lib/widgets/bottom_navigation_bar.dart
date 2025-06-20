import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Comprar',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Categorías',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Más vendidos',
          ),

        BottomNavigationBarItem(
          icon: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey, // Cambiar luego por una imagen
            ),
            child: const Icon(Icons.star, size: 16, color: Colors.white),
          ),
          label: 'Populares',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Carrito',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Yo',
        ),
      ],
    );
  }
}
