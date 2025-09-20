import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/bloc/profile_bloc.dart';
import '../../data/bloc/profile_event.dart';
import '../../data/bloc/profile_state.dart';
import '../views/profile_error_view.dart';
import '../views/profile_initial_view.dart';
import '../views/profile_loading_view.dart';
import '../views/profile_success_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Key para forzar reconstrucción del FutureBuilder
  Key _futureBuilderKey = UniqueKey();

  Future<bool> _hasUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userData = prefs.getString('user_data');

      return token != null && userData != null;
    } catch (e) {
      return false;
    }
  }

  void _onTokenExpired() {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      key: _futureBuilderKey, // Key para forzar reconstrucción
      future: _hasUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ProfileLoadingView();
        }

        // Si no hay usuario, mostrar vista inicial
        if (!snapshot.data!) {
          return const ProfileInitialView();
        }

        // Si hay usuario, cargar Bloc normalmente
        return BlocProvider(
          create: (_) {
            return sl<ProfileBloc>()..add(LoadProfile());
          },
          child: Scaffold(
            body: Center(
              child: BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileTokenExpired) {
                    _onTokenExpired();
                  }
                },
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const ProfileLoadingView();
                    } else if (state is ProfileTokenExpired) {
                      return const ProfileLoadingView();
                    } else if (state is ProfileError) {
                      return ProfileErrorView(
                        message: "Error al cargar perfil",
                        onRetry: () {
                          context.read<ProfileBloc>().add(LoadProfile());
                        },
                      );
                    } else if (state is ProfileLoaded) {
                      return ProfileSuccessView(
                          user: state.user,
                          onLogout: () async {
                            context.read<ProfileBloc>().add(LogoutRequested());
                          },
                          onRefresh: () async {
                            context.read<ProfileBloc>().add(LoadProfile());
                          });
                    }

                    return const ProfileInitialView();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
