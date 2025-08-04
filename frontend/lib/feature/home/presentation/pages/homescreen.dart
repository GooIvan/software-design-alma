import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/home_bloc.dart';
import '../views/home_loading_view.dart';
import '../views/home_error_view.dart';
import '../views/home_success_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) return const HomeLoadingView();
            if (state is HomeError) {
              return HomeErrorView(
                message: state.message,
                onRetry: () {
                  context.read<HomeBloc>().add(LoadHome());
                },
              );
            }
            if (state is HomeLoaded) {
              return HomeSuccessView(
                products: state.products,
                categories: state.categories,
                onRefresh: () async {
                  context.read<HomeBloc>().add(LoadHome());
                },
              );
            }

            return const SizedBox(); // fallback
          },
        ),
    );
  }
}
