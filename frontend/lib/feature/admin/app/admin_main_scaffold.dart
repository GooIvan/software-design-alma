import 'package:design_alma/feature/admin/dashboard/presentation/page/dashboard_page.dart';
import 'package:design_alma/feature/admin/users/presentation/page/users_page.dart';
import 'package:flutter/material.dart';

import '../widgets/admin_custom_appbar.dart';
import '../widgets/admin_custom_bottom_navbar.dart';

class AdminMainScaffold extends StatefulWidget {
  final int initialIndex;

  const AdminMainScaffold({super.key, this.initialIndex = 0});

  @override
  State<AdminMainScaffold> createState() => _AdminMainScaffoldState();
}

class _AdminMainScaffoldState extends State<AdminMainScaffold> {
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
      const AdminDashboardPage(),
      const AdminUsersPage(),
    ];

    return Scaffold(
      appBar: const AdminCustomAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: AdminCustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
