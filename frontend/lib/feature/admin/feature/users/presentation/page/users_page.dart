import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/di/service_locator.dart';
import '../../data/bloc/users_bloc.dart';
import '../../data/repository/users_repository.dart';
import '../views/users_error_view.dart';
import '../views/users_loading_view.dart';
import '../views/users_success_view.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(sl<UsersRepository>())..add(LoadUsers()),
      child: SafeArea(
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const UsersLoadingView();
            }
            if (state is UsersError) {
              return UsersErrorView(
                message: state.message,
                onRetry: () {
                  context.read<UsersBloc>().add(LoadUsers());
                },
              );
            }
            if (state is UsersLoaded) {
              return UsersSuccessView(
                users: state.users,
                onRefresh: () async {
                  context.read<UsersBloc>().add(LoadUsers());
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
