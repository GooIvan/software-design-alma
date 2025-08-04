import 'package:design_alma/widgets/custom_appbar.dart';
import 'package:design_alma/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature/categories/presentation/pages/categories_screen.dart';
import '../feature/home/presentation/pages/homescreen.dart';
import '../feature/home/data/bloc/home_bloc.dart';
import '../feature/home/data/repositories/home_repository.dart';
import '../feature/profile/pages/profile_page.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _homeBloc = HomeBloc(HomeRepository())..add(LoadHome());
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages = [
    BlocProvider.value(
      value: _homeBloc,
      child: const HomeScreen(),
    ),
    const CategoriesScreen(),
    const Placeholder(),
    const Placeholder(),
    const PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
