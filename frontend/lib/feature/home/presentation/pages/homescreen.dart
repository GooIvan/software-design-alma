import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../feature/cart/data/bloc/cart_bloc.dart';
import '../../data/bloc/category/category_bloc.dart';
import '../../data/bloc/product/product_bloc.dart';
import '../views/categories/views_categories_error.dart';
import '../views/categories/views_categories_loading.dart';
import '../views/categories/views_categories_success.dart';
import '../views/products/views_products_error.dart';
import '../views/products/views_products_loading.dart';
import '../views/products/views_products_success.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Future<void> _refreshData(BuildContext context) async {
    sl<ProductBloc>().add(LoadProducts());
    sl<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<ProductBloc>()..add(LoadProducts())),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _refreshData(context),
            color: Colors.black,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Banner promocional
                  PromoBanner(context),
                  const SizedBox(height: 24),

                  // Título y productos populares
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          'Lo más nuevo',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const ViewProductsLoading();
                      } else if (state is ProductError) {
                        return ViewProductsError(
                          title: 'Error al cargar productos',
                          onRetry: () {
                            context.read<ProductBloc>().add(LoadProducts());
                          },
                        );
                      } else if (state is ProductLoaded) {
                        return ViewProductsSuccess(products: state.products);
                      }
                      return const SizedBox();
                    },
                  ),

                  // Título y categorías
                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Categorías',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const ViewsCategoriesLoading();
                      } else if (state is CategoryError) {
                        return ViewCategoriesError(
                          title: 'Error al cargar categorías',
                          onRetry: () {
                            context.read<CategoryBloc>().add(LoadCategories());
                          },
                        );
                      } else if (state is CategoryLoaded) {
                        return ViewCategoriesSuccess(
                            categories: state.categories);
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
