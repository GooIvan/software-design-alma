import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/bloc/product_bloc.dart';
import '../views/product_error_view.dart';
import '../views/product_loading_view.dart';
import '../views/product_success_view.dart';

class ProductScreen extends StatelessWidget {
  final String categoryName;

  const ProductScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductBloc>()..add(LoadProducts(categoryName)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            categoryName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const ProductLoadingView();
            }
            if (state is ProductError) {
              return ProductErrorView(
                categoryName: categoryName,
                message: 'Error al cargar los productos',
              );
            }
            if (state is ProductLoaded) {
              return ProductSuccessView(
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
