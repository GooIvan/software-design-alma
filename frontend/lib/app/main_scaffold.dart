import 'package:design_alma/widgets/custom_appbar.dart';
import 'package:design_alma/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../feature/categories/presentation/pages/categories_screen.dart';
import '../feature/home/presentation/pages/homescreen.dart';
import '../feature/home/data/bloc/blocs.dart';
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
  late final ProductBloc _productBloc;
  late final CategoryBloc _categoryBloc;
  bool _isLoggedIn = false;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    final repository = HomeRepository();
    _productBloc = ProductBloc(repository)..add(LoadProducts());
    _categoryBloc = CategoryBloc(repository)..add(LoadCategories());
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _storage.read(key: 'authToken');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  void dispose() {
    _productBloc.close();
    _categoryBloc.close();
    super.dispose();
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
          BlocProvider.value(value: _productBloc),
          BlocProvider.value(value: _categoryBloc),
        ],
        child: const HomeScreen(),
      ),
      const CategoriesScreen(),
      const Placeholder(),
      const Placeholder(),
      const PerfilPage(),
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
