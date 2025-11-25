import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/dashboard_model.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/orders_bar_chart.dart';

class DashboardSuccessView extends StatelessWidget {
  final DashboardModel dashboard;
  final Future<void> Function()? onRefresh;

  const DashboardSuccessView({
    super.key,
    required this.dashboard,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_CO', symbol: '', decimalDigits: 0);

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: onRefresh ?? () async {},
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AdminStatCard(
                        value: dashboard.activeUsersCount,
                        label: context.l10n.usersCount,
                        icon: Icons.group),
                    AdminStatCard(
                      value: currencyFormat.format(dashboard.totalRevenue),
                      label: context.l10n.totalRevenue,
                      icon: Icons.attach_money,
                      iconColor: Colors.blue,
                      iconBackground: const Color(0xFFE6F0FA),
                    ),
                    AdminStatCard(
                      value: dashboard.paidOrdersCount,
                      label: context.l10n.paidOrdersCount,
                      icon: Icons.shopping_cart,
                      iconColor: Colors.green,
                      iconBackground: const Color(0xFFE6F4EA),
                    ),
                    AdminStatCard(
                      value: dashboard.totalPendingOrders,
                      label: context.l10n.pendingOrdersCount,
                      icon: Icons.pending_actions,
                      iconColor: Colors.orange,
                      iconBackground: const Color(0xFFFFF4E5),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                OrdersLineChart(data: dashboard.ordersPerMonth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
