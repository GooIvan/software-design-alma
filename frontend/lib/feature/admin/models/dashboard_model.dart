class PopularCategory {
  final String name;
  final int soldCount;

  PopularCategory({required this.name, required this.soldCount});

  factory PopularCategory.fromJson(Map<String, dynamic> json) {
    return PopularCategory(
      name: json['name'],
      soldCount: json['sold_count'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String createdAt;
  final String updatedAt;
  final int categoryId;
  final List<String> sizes;
  final int? soldCount; // solo para top_products

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.sizes,
    this.soldCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['category_id'],
      sizes: List<String>.from(json['sizes']),
      soldCount: json['sold_count'],
    );
  }
}

class OrdersPerMonth {
  final String month;
  final int count;

  OrdersPerMonth({required this.month, required this.count});

  factory OrdersPerMonth.fromJson(Map<String, dynamic> json) {
    return OrdersPerMonth(
      month: json['month'],
      count: json['count'],
    );
  }
}

class DashboardModel {
  final int activeUsersCount;
  final int paidOrdersCount;
  final int totalPendingOrders;
  final double totalRevenue;
  final List<PopularCategory> popularCategories;
  final List<Product> topProducts;
  final List<OrdersPerMonth> ordersPerMonth;
  final List<Product> lowStockProducts;

  DashboardModel({
    required this.activeUsersCount,
    required this.paidOrdersCount,
    required this.totalPendingOrders,
    required this.totalRevenue,
    required this.popularCategories,
    required this.topProducts,
    required this.ordersPerMonth,
    required this.lowStockProducts,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      activeUsersCount: json['active_users_count'],
      paidOrdersCount: json['paid_orders_count'],
      totalPendingOrders: json['total_pending_orders'],
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      popularCategories: (json['popular_categories'] as List)
          .map((e) => PopularCategory.fromJson(e))
          .toList(),
      topProducts: (json['top_products'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
      ordersPerMonth: (json['orders_per_month'] as List)
          .map((e) => OrdersPerMonth.fromJson(e))
          .toList(),
      lowStockProducts: (json['low_stock_products'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}
