import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/categories_bloc.dart';
import '../../data/repositories/categories_repository.dart';
import '../views/categories_loading_view.dart';
import '../views/categories_error_view.dart';
import '../views/categories_success_view.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesBloc(CategoriesRepository())..add(LoadCategories()),
      child: SafeArea(
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const CategoriesLoadingView();
            }
            if (state is CategoriesError) {
              return CategoriesErrorView(
                message: state.message,
                onRetry: () {
                  context.read<CategoriesBloc>().add(LoadCategories());
                },
              );
            }
            if (state is CategoriesLoaded) {
              return CategoriesSuccessView(
                categories: state.categories,
                onRefresh: () async {
                  context.read<CategoriesBloc>().add(LoadCategories());
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
