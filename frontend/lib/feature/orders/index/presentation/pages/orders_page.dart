import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart';
import '../../data/bloc/orders_bloc.dart';
import '../../data/repositories/orders_repository.dart';
import '../views/orders_error_view.dart';
import '../views/orders_loading_view.dart';
import '../views/orders_success_view.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersBloc(sl<OrdersRepository>())..add(LoadOrders()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            context.l10n.ordersTitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.displayLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              if (state is OrdersLoading) {
                return const OrdersLoadingView();
              }
              if (state is OrdersError) {
                return OrdersErrorView(
                  onRetry: () {
                    context.read<OrdersBloc>().add(LoadOrders());
                  },
                );
              }
              if (state is OrdersLoaded) {
                return OrdersSuccessView(
                  orders: state.orders,
                  onRefresh: () async {
                    context.read<OrdersBloc>().add(LoadOrders());
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
