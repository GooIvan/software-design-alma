import 'package:design_alma/widgets/custom_appbar.dart';
import 'package:design_alma/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

import '../feature/categories/presentation/pages/categories_screen.dart';
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
    const CategoriesScreen(),
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
      appBar: const CustomAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
