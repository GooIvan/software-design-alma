import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/category/category_bloc.dart';
import '../../data/bloc/product/product_bloc.dart';
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
              // En todos los casos, mostrar vista success pero este valida si products o categories son null o no, para mostrar el contenido correcto
              return HomeSuccessView(
                products: productState is ProductLoaded
                    ? productState.products
                    : null,
                categories: categoryState is CategoryLoaded
                    ? categoryState.categories
                    : null,
                isProductLoading: productState is ProductLoading ||
                    productState is ProductInitial,
                isCategoryLoading: categoryState is CategoryLoading ||
                    categoryState is CategoryInitial,
                productError:
                    productState is ProductError ? productState.message : null,
                categoryError: categoryState is CategoryError
                    ? categoryState.message
                    : null,
                onRetryProducts: () =>
                    context.read<ProductBloc>().add(LoadProducts()),
                onRetryCategories: () =>
                    context.read<CategoryBloc>().add(LoadCategories()),
                onRefresh: () async {
                  final productBloc = context.read<ProductBloc>();
                  final categoryBloc = context.read<CategoryBloc>();

                  productBloc.add(RefreshProducts());
                  categoryBloc.add(RefreshCategories());
                  try {
                    print('✅ Refresh completado');
                  } catch (e) {
                    print('⚠️ Timeout o error en refresh: $e');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
