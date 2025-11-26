import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../data/bloc/admin_products_bloc.dart';
import '../../data/repository/admin_products.dart';
import '../views/admin_products_error_view.dart';
import '../views/admin_products_loading_view.dart';
import '../views/admin_products_success_view.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminProductsBloc(sl<AdminProductsRepository>())
        ..add(LoadAdminProducts()),
      child: Scaffold(
        body: BlocBuilder<AdminProductsBloc, AdminProductsState>(
          builder: (context, state) {
            if (state is AdminProductsLoading) {
              return const AdminProductsLoadingView();
            } else if (state is AdminProductsLoaded) {
              return AdminProductsSuccessView(
                dashboard: state.products,
                onRefresh: () async {
                  context.read<AdminProductsBloc>().add(RefreshAdminProducts());
                },
              );
            } else if (state is AdminProductsError) {
              return AdminProductsErrorView(
                message: context.l10n.homeErrorMessageProducts,
                onRetry: () {
                  context.read<AdminProductsBloc>().add(RefreshAdminProducts());
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
