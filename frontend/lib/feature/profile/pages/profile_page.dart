import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/perfil_bloc.dart';
import '../bloc/perfil_event.dart';
import '../bloc/perfil_state.dart';
import '../views/perfil_loading_view.dart';
import '../views/perfil_error_view.dart';
import '../views/perfil_view.dart';
import '../../../routes/routes.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');

    Navigator.pushNamedAndRemoveUntil(context, AppRoute.main, (route) => false);
  }

  void _iniciarSesion(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PerfilBloc()..add(CargarPerfil()),
      child: Scaffold(
        body: BlocBuilder<PerfilBloc, PerfilState>(
          builder: (context, state) {
            if (state is PerfilLoading) {
              return const PerfilLoadingView();
            } else if (state is PerfilError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.mensaje),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PerfilBloc>().add(CargarPerfil()),
                      child: const Text('Reintentar'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _iniciarSesion(context),
                      child: const Text('Iniciar sesión'),
                    ),
                  ],
                ),
              );
            } else if (state is PerfilLoaded) {
              return PerfilView(
                nombreUsuario: state.nombreUsuario,
                onCerrarSesion: () => _cerrarSesion(context),
              );
            }


            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No has iniciado sesión.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _iniciarSesion(context),
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
