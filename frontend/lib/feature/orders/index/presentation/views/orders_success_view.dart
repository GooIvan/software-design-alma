import 'package:design_alma/feature/orders/show/presentation/pages/order_page.dart';
import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../models/order_model.dart';

enum OrderFilter { all, paid, pending, cancelled }

enum OrderSort { dateDesc, dateAsc, amountDesc, amountAsc }

class OrdersSuccessView extends StatefulWidget {
  final List<Order> orders;
  final Future<void> Function()? onRefresh;

  const OrdersSuccessView({
    super.key,
    required this.orders,
    required this.onRefresh,
  });

  @override
  State<OrdersSuccessView> createState() => _OrdersSuccessViewState();
}

class _OrdersSuccessViewState extends State<OrdersSuccessView> {
  OrderFilter _selectedFilter = OrderFilter.all;
  OrderSort _selectedSort = OrderSort.dateDesc;

  Color _getStatusColor(Order order) {
    if (order.isPaid) return Colors.green;
    if (order.isCancelled) return Colors.red;
    return Colors.orange;
  }

  String _formatTotal(double total) {
    final formatter = NumberFormat('#,##0', 'es_CO');
    return '\$${formatter.format(total)}';
  }

  double _calculateSubtotal(Order order) {
    // Si hay subtotal disponible, usarlo
    if (order.subtotal != null) {
      return order.subtotal!;
    }

    // Si hay descuento, calcular subtotal original
    if (order.discountAmount != null && order.discountAmount! > 0) {
      return order.total + order.discountAmount!;
    }

    // Si no hay descuento, el subtotal es igual al total
    return order.total;
  }

  Widget _buildPriceInfo(Order order, BuildContext context) {
    final hasDiscount = order.discountCode != null &&
        order.discountAmount != null &&
        order.discountAmount! > 0;

    if (!hasDiscount) {
      return Text(
        _formatTotal(order.total),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Theme.of(context).textTheme.displayLarge?.color,
        ),
      );
    }

    final subtotal = _calculateSubtotal(order);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.subtotalBeforeDiscount}: ${_formatTotal(subtotal)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              Icons.local_offer,
              size: 12,
              color: Colors.green[600],
            ),
            const SizedBox(width: 4),
            Text(
              '${context.l10n.discountAmount} (${order.discountCode}): -${_formatTotal(order.discountAmount!)}',
              style: TextStyle(
                color: Colors.green[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${context.l10n.total}: ${_formatTotal(order.total)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
      ],
    );
  }

  String _getFilterLabel(OrderFilter filter, BuildContext context) {
    switch (filter) {
      case OrderFilter.all:
        return context.l10n.all;
      case OrderFilter.paid:
        return context.l10n.paid;
      case OrderFilter.pending:
        return context.l10n.pending;
      case OrderFilter.cancelled:
        return context.l10n.cancelled;
    }
  }

  String _getSortLabel(OrderSort sort, BuildContext context) {
    switch (sort) {
      case OrderSort.dateDesc:
        return context.l10n.newest;
      case OrderSort.dateAsc:
        return context.l10n.oldest;
      case OrderSort.amountDesc:
        return context.l10n.higherValue;
      case OrderSort.amountAsc:
        return context.l10n.lowerValue;
    }
  }

  IconData _getSortIcon(OrderSort sort) {
    switch (sort) {
      case OrderSort.dateDesc:
        return Icons.schedule;
      case OrderSort.dateAsc:
        return Icons.history;
      case OrderSort.amountDesc:
        return Icons.trending_up;
      case OrderSort.amountAsc:
        return Icons.trending_down;
    }
  }

  List<Order> _getFilteredAndSortedOrders() {
    List<Order> filtered = widget.orders;

    // Aplicar filtro
    switch (_selectedFilter) {
      case OrderFilter.all:
        break;
      case OrderFilter.paid:
        filtered = filtered.where((order) => order.isPaid).toList();
        break;
      case OrderFilter.pending:
        filtered = filtered
            .where((order) => !order.isPaid && !order.isCancelled)
            .toList();
        break;
      case OrderFilter.cancelled:
        filtered = filtered.where((order) => order.isCancelled).toList();
        break;
    }

    // Aplicar ordenamiento
    switch (_selectedSort) {
      case OrderSort.dateDesc:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case OrderSort.dateAsc:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case OrderSort.amountDesc:
        filtered.sort((a, b) => b.total.compareTo(a.total));
        break;
      case OrderSort.amountAsc:
        filtered.sort((a, b) => a.total.compareTo(b.total));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _getFilteredAndSortedOrders();

    if (widget.orders.isEmpty) {
      return Center(
        child: Text(
          context.l10n.ordersNotFound,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Filtros y ordenamiento
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtros por estado
              Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.grey[600], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.filterby,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: OrderFilter.values.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(_getFilterLabel(filter, context)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor ??
                                Colors.white,
                        selectedColor: Colors.black,
                        side: BorderSide(
                          color: isSelected
                              ? Colors.black
                              : Theme.of(context).dividerColor,
                          width: 1.2,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        checkmarkColor: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Ordenamiento
              Row(
                children: [
                  Icon(Icons.sort, color: Colors.grey[600], size: 18),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.sortby,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: OrderSort.values.map((sort) {
                    final isSelected = _selectedSort == sort;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSort = sort;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor ??
                                    Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Theme.of(context).dividerColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getSortIcon(sort),
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getSortLabel(sort, context),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[700],
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Contador de resultados
        if (filteredOrders.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredOrders.length} ${filteredOrders.length == 1 ? context.l10n.orderFound : context.l10n.ordersFound}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_selectedFilter != OrderFilter.all ||
                    widget.orders.length != filteredOrders.length)
                  Text(
                    ' ${context.l10n.oF} ${widget.orders.length} ${context.l10n.total}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

        // Lista de órdenes
        Expanded(
          child: filteredOrders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.noOrdersFilterFound,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = OrderFilter.all;
                          });
                        },
                        child: Text(context.l10n.clearFilters),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: Colors.black,
                  onRefresh: widget.onRefresh!,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final statusColor = _getStatusColor(order);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              // Borde lateral de estado
                              Container(
                                width: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                              ),
                              // Contenido de la tarjeta
                              Expanded(
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              OrderPage(orderId: order.id)),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${context.l10n.order} #${order.orderNumber}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                '${order.itemsCount} ${order.itemsCount == 1 ? context.l10n.article : context.l10n.articles}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              _buildPriceInfo(order, context),
                                              const SizedBox(height: 8),
                                              Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    order.createdAt.toLocal()),
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey[400],
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
