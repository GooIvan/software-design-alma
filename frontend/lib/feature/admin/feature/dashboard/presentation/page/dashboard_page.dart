import 'package:design_alma/feature/admin/feature/dashboard/data/bloc/dashboard_bloc.dart';
import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/service_locator.dart';
import '../../data/repository/dashboard_repository.dart';
import '../views/dashboard_error_view.dart';
import '../views/dashboard_loading_view.dart';
import '../views/dashboard_success_view.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DashboardBloc(sl<DashboardRepository>())..add(LoadDashboard()),
      child: Scaffold(
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const DashboardLoadingView();
            } else if (state is DashboardLoaded) {
              return DashboardSuccessView(
                dashboard: state.dashboard,
                onRefresh: () async {
                  context.read<DashboardBloc>().add(RefreshDashboard());
                },
              );
            } else if (state is DashboardError) {
              return DashboardErrorView(
                message: context.l10n.errorLoadingDashboard,
                onRetry: () {
                  context.read<DashboardBloc>().add(RefreshDashboard());
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
