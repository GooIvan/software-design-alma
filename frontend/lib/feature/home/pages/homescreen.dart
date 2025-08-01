import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../repositories/product_repository.dart';
import '../views/home_loading_view.dart';
import '../views/home_error_view.dart';
import '../views/home_success_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(ProductRepository())..add(LoadProducts()),
      child: SafeArea(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) return const HomeLoadingView();
            if (state is ProductError) {
              return HomeErrorView(message: state.message);
            }
            if (state is ProductLoaded) {
              return HomeSuccessView(products: state.products);
            }

            return const SizedBox(); // fallback
          },
        ),
      ),
    );
  }
}
