import 'package:flutter/material.dart';

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
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 32),
                activeIcon: Icon(Icons.home, size: 32),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_search_outlined, size: 32),
                activeIcon: Icon(Icons.manage_search, size: 32),
                label: 'Categorías',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 32),
                activeIcon: Icon(Icons.shopping_cart, size: 32),
                label: 'Carrito',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 32),
                activeIcon: Icon(Icons.person, size: 32),
                label: 'Yo',
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          child: GestureDetector(
            onTap: () => onTap(2),
            child: SizedBox(
              width: 70,
              height: 70,
              child: Image.asset('assets/icon_trending.png'),
            ),
          ),
        ),
      ],
    );
  }
}
