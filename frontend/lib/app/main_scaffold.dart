import 'package:flutter/material.dart';

import '../feature/home/presentation/pages/homescreen.dart';
import '../feature/profile/pages/profile_page.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Placeholder(),
    const Placeholder(),
    const Placeholder(),
    const PerfilPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
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
            bottom: 5,
            child: GestureDetector(
              onTap: () => _onItemTapped(2),
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.asset('assets/icon_trending.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
