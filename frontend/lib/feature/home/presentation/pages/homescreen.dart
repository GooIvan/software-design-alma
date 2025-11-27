import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../../../utils/extensions.dart';
import '../widgets/seccion_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<ProductBloc>().add(LoadProducts());
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  promoBanner(context),
                  const SizedBox(height: 24),

                  // Productos populares
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          context.l10n.homeNewest,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
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
                          title: context.l10n.homeErrorMessageProducts,
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

                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      context.l10n.categories,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displayLarge?.color,
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
                          title: context.l10n.homeErrorMessageCategories,
                          onRetry: () {
                            context.read<CategoryBloc>().add(LoadCategories());
                          },
                        );
                      } else if (state is CategoryLoaded) {
                        return ViewCategoriesSuccess(
                          categories: state.categories,
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  const SizedBox(height: 32),

                  const SeccionMap(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
