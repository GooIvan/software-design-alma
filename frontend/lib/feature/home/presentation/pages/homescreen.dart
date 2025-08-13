import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/bloc/product/product_bloc.dart';
import '../views/products/views_products_error.dart';
import '../views/products/views_products_loading.dart';
import '../views/products/views_products_success.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
return Scaffold(
  body: SafeArea(
    child: SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<ProductBloc, ProductState>(
            bloc: sl<ProductBloc>(),
            builder: (context, state) {
              if (state is ProductLoading) {
                //?: Vista de carga
                return const Column(
                  children: [
                    SizedBox(height: 16),
                    Align(
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
                    SizedBox(height: 16),
                    ViewProductsLoading(),
                  ],
                );
                //return const ViewProductsLoading();
              } else if (state is ProductError) {
                  //! Vista de error
                  return const Column(
                    children: [
                      SizedBox(height: 16),
                      Align(
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
                      SizedBox(height: 16),
                      ViewProductsError(title: 'Error al cargar productos'),
                    ],
                  );
              } else if (state is ProductLoaded) {
                return Column(
                  children: [
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
                    ViewProductsSuccess(products: state.products),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    ),
  ),
);

  }
}
