import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart';
import '../../data/bloc/order_bloc.dart';
import '../../data/repositories/order_repository.dart';
import '../views/order_error_view.dart';
import '../views/order_loading_view.dart';
import '../views/order_success_view.dart';

class OrderPage extends StatelessWidget {
  final int orderId;
  const OrderPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderBloc(sl<OrderRepository>())..add(LoadOrder(orderId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const OrderLoadingView();
              }
              if (state is OrderError) {
                return OrderErrorView(
                  onRetry: () {
                    context.read<OrderBloc>().add(LoadOrder(orderId));
                  },
                );
              }
              if (state is OrderLoaded) {
                return OrderSuccessView(
                  order: state.order,
                  onRefresh: () async {
                    context.read<OrderBloc>().add(RefreshOrder(orderId));
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
