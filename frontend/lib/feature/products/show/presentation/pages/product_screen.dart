import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/service_locator.dart';
import '../../data/bloc/product_bloc.dart';
import '../views/product_error_view.dart';
import '../views/product_loading_view.dart';
import '../views/product_success_view.dart';

class ProductScreen extends StatelessWidget {
  final String categoryName;
  final int id;

  const ProductScreen(
      {super.key, required this.categoryName, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProductBloc>()..add(LoadProduct(categoryName, id)),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const ProductLoadingView();
              }
              if (state is ProductError) {
                return ProductErrorView(
                  message: context.l10n.errorLoadingProductDetails,
                  onRetry: () {
                    context
                        .read<ProductBloc>()
                        .add(LoadProduct(categoryName, id));
                  },
                );
              }
              if (state is ProductLoaded) {
                return ProductSuccessView(product: state.product);
              }
              return const SizedBox();
            },
          )),
    );
  }
}
