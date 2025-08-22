import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/bloc/category_bloc.dart';
import '../../data/repositories/categories_repository.dart';
import '../views/categories_loading_view.dart';
import '../views/categories_error_view.dart';
import '../views/categories_success_view.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryBloc(sl<CategoryRepository>())..add(LoadCategories()),
      child: SafeArea(
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const CategoriesLoadingView();
            }
            if (state is CategoryError) {
              return CategoriesErrorView(
                message: state.message,
                onRetry: () {
                  context.read<CategoryBloc>().add(LoadCategories());
                },
              );
            }
            if (state is CategoryLoaded) {
              return CategoriesSuccessView(
                categories: state.categories,
                onRefresh: () async {
                  context.read<CategoryBloc>().add(LoadCategories());
                },
              );
            }
            return const SizedBox(); // fallback
          },
        ),
      ),
    );
  }
}
