import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/bloc/profile_bloc.dart';
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
      final token = prefs.getString('auth_token') ?? prefs.getString('token');
      final userEmail = prefs.getString('user_email');
      final userData = prefs.getString('user_data');

      // Validar que tenga token Y (user_email O user_data)
      return token != null && token.isNotEmpty && (userEmail != null || userData != null);
    } catch (e) {
      return false;
    }
  }

  void _onTokenExpired() {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  // Lógica de logout
  Future<void> _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Limpiar tokens de ambos sistemas (auth_token y token)
      await prefs.remove('auth_token');
      await prefs.remove('token');
      await prefs.remove('user_data');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_photo_url');

      setState(() {
        _futureBuilderKey = UniqueKey();
      });
    } catch (e) {
      print('Error en logout: $e');
    }
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
                    message: context.l10n.profileErrorMessage,
                    onRetry: () {
                      context.read<ProfileBloc>().add(LoadProfile());
                    },
                    onLogout: _handleLogout,
                  );
                } else if (state is ProfileLoaded) {
                  return ProfileSuccessView(
                    user: state.user,
                    onLogout: _handleLogout,
                    onRefresh: () async {
                      context.read<ProfileBloc>().add(LoadProfile());
                    },
                  );
                }
                return const ProfileInitialView();
              },
            ),
          ),
        );
      },
    );
  }
}
