import 'package:flutter/material.dart';
import '../widgets/admin_stat_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220, // ancho máximo por tarjeta
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          children: const [
            AdminStatCard(
              value: 6,
              label: "Total Listings",
              icon: Icons.home_outlined,
            ),
            AdminStatCard(
              value: 12,
              label: "Users",
              icon: Icons.person_outline,
              iconColor: Colors.green,
              iconBackground: Color.fromARGB(242, 201, 255, 140),
            ),
            AdminStatCard(
              value: 3,
              label: "Orders",
              icon: Icons.shopping_bag_outlined,
              iconColor: Colors.orange,
              iconBackground: Color.fromARGB(255, 255, 223, 178),
            ),
            AdminStatCard(
              value: 5,
              label: "Reviews",
              icon: Icons.star_border,
              iconColor: Colors.blue,
              iconBackground: Color.fromARGB(255, 179, 223, 255),
            ),
          ],
        ),
      ),
    );
  }
}
