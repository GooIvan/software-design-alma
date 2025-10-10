import 'package:design_alma/widgets/custom_appbar.dart';
import 'package:design_alma/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/service_locator.dart';
import '../feature/categories/presentation/pages/categories_screen.dart';
import '../feature/home/data/bloc/category/category_bloc.dart';
import '../feature/home/data/bloc/product/product_bloc.dart';
import '../feature/home/presentation/pages/homescreen.dart';
import '../feature/profile/presentation/pages/profile_page.dart';
import '../feature/favorites/presentation/pages/empty_favorites_page.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

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
    final List<Widget> pages = [
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<ProductBloc>()..add(LoadProducts()),
          ),
          BlocProvider(
            create: (_) => sl<CategoryBloc>()..add(LoadCategories()),
          ),
        ],
        child: const HomeScreen(),
      ),
      const CategoriesScreen(),
      const EmptyFavoritesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
