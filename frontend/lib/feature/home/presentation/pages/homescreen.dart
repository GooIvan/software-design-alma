import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/bloc/category/category_bloc.dart';
import '../../data/bloc/product/product_bloc.dart';
import '../views/categories/views_categories_error.dart';
import '../views/categories/views_categories_loading.dart';
import '../views/categories/views_categories_success.dart';
import '../views/products/views_products_error.dart';
import '../views/products/views_products_loading.dart';
import '../views/products/views_products_success.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<ProductBloc>(),
        ),
        BlocProvider.value(
          value: sl<CategoryBloc>(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //?: bloc relacionado a los productos
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Lo nuevo',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      //?: Vista de carga
                      return const ViewProductsLoading();
                    } else if (state is ProductError) {
                      //! Vista de error
                      return const ViewProductsError(
                          title: 'Error al cargar productos');
                    } else if (state is ProductLoaded) {
                      return ViewProductsSuccess(products: state.products);
                    }
                    return const SizedBox();
                  },
                ),
                //?: bloc relacionado a las categorías
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Categorías',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      //?: Vista de carga
                      return const ViewsCategoriesLoading();
                    } else if (state is CategoryError) {
                      //! Vista de error
                      return const ViewCategoriesError(
                          title: 'Error al cargar categorías');
                    } else if (state is CategoryLoaded) {
                      return ViewCategoriesSuccess(
                          categories: state.categories);
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
