import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/blocs.dart';
import '../views/errors/home_error_view.dart';
import '../views/home_success_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, productState) {
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              // Solo mostrar error completo si AMBOS fallan en el primer intento
              if (productState is ProductError && 
                  categoryState is CategoryError &&
                  productState is! ProductLoaded && 
                  categoryState is! CategoryLoaded) {
                return HomeErrorView(
                  message: "Error al cargar productos y categorías",
                  onRetry: () {
                    context.read<ProductBloc>().add(LoadProducts());
                    context.read<CategoryBloc>().add(LoadCategories());
                  },
                );
              }

              // En todos los demás casos, mostrar vista parcial con manejo independiente
              return HomeSuccessView(
                products: productState is ProductLoaded ? productState.products : null,
                categories: categoryState is CategoryLoaded ? categoryState.categories : null,
                isProductLoading: productState is ProductLoading || productState is ProductInitial,
                isCategoryLoading: categoryState is CategoryLoading || categoryState is CategoryInitial,
                productError: productState is ProductError ? productState.message : null,
                categoryError: categoryState is CategoryError ? categoryState.message : null,
                onRetryProducts: () => context.read<ProductBloc>().add(LoadProducts()),
                onRetryCategories: () => context.read<CategoryBloc>().add(LoadCategories()),
                onRefresh: () async {
                  context.read<ProductBloc>().add(RefreshProducts());
                  context.read<CategoryBloc>().add(RefreshCategories());
                },
              );
            },
          );
        },
      ),
    );
  }
}
