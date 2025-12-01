import 'dart:async';
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

  // Timer para detectar timeout
  Timer? _timeoutTimer;

  Future<bool> _hasUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? prefs.getString('token');
      final userEmail = prefs.getString('user_email');
      final userData = prefs.getString('user_data');

      // Validar token + datos
      return token != null &&
          token.isNotEmpty &&
          (userEmail != null || userData != null);
    } catch (e) {
      return false;
    }
  }

  void _onTokenExpired() {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  // Lógica de logout REAL
  Future<void> _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

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

  // Timeout

  void _startTimeout() {
    _timeoutTimer?.cancel();

    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      // Si después de 10s sigue cargando => logout automático
      _handleLogout();
    });
  }

  void _cancelTimeout() {
    _timeoutTimer?.cancel();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      key: _futureBuilderKey,
      future: _hasUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ProfileLoadingView();
        }

        // Si no hay usuario → vista inicial
        if (!snapshot.data!) {
          return const ProfileInitialView();
        }

        // Si sí hay usuario → cargar Bloc
        return BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoading) {
                _startTimeout(); // empieza contador
              } else if (state is ProfileLoaded) {
                _cancelTimeout(); // se cargó, cancelar
              } else if (state is ProfileError) {
                _cancelTimeout();
              } else if (state is ProfileTokenExpired) {
                _cancelTimeout();
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
