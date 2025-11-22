import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../favorites/data/bloc/favorites_bloc.dart';
import '../../data/bloc/products_bloc.dart';
import '../views/products_error_view.dart';
import '../views/products_loading_view.dart';
import '../views/products_success_view.dart';

class ProductsScreen extends StatelessWidget {
  final String categoryName;

  const ProductsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<ProductsBloc>()..add(LoadProducts(categoryName)),
        ),
        BlocProvider(
          create: (context) => FavoritesBloc(sl()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            categoryName,
            style: TextStyle(
              color: Theme.of(context).textTheme.displayLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const ProductsLoadingView();
            }
            if (state is ProductsError) {
              return ProductsErrorView(
                categoryName: categoryName,
                message: 'Error al cargar los productos',
                onRetry: () {
                  context.read<ProductsBloc>().add(LoadProducts(categoryName));
                },
              );
            }
            if (state is ProductsLoaded) {
              return ProductsSuccessView(
                products: state.products,
              );
            }
            return const SizedBox(); // fallback
          },
        ),
      ),
    );
  }
}
