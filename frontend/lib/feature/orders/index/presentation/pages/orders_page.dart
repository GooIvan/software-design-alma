import 'package:design_alma/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/service_locator.dart';
import '../../data/bloc/orders_bloc.dart';
import '../../data/repositories/orders_repository.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersBloc(sl<OrdersRepository>())..add(LoadOrders()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Órdenes'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: BlocListener<OrdersBloc, OrdersState>(
            listener: (context, state) {
              if (state is OrdersError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Error al cargar las órdenes: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is OrdersError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<OrdersBloc>().add(LoadOrders());
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is OrdersLoaded) {
                  if (state.orders.isEmpty) {
                    return const Center(child: Text('No tienes órdenes aún.'));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        final order = state.orders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              'Orden #${order.orderNumber}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('${order.itemsCount} artículos'),
                                Text('Total: ${order.formattedTotal}'),
                                Text(
                                  'Estado: ${order.statusDisplay}',
                                  style: TextStyle(
                                    color: order.isPaid
                                        ? Colors.green
                                        : order.isCancelled
                                            ? Colors.red
                                            : Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  order.createdAt
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navegar a detalles de la orden si es necesario
                              CustomAlert.success(context,
                                  'Orden ${order.orderNumber} seleccionada');
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox(); // fallback
              },
            ),
          ),
        ),
      ),
    );
  }
}
