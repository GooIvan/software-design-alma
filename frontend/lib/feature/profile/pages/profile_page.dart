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

    // Navegar al login eliminando historial
    Navigator.pushNamedAndRemoveUntil(context, AppRoute.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PerfilBloc()..add(CargarPerfil()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          backgroundColor: const Color.fromARGB(255, 70, 140, 247),
          // Eliminamos el botón de cerrar sesión del AppBar
        ),
        body: BlocBuilder<PerfilBloc, PerfilState>(
          builder: (context, state) {
            if (state is PerfilLoading) {
              return const PerfilLoadingView();
            } else if (state is PerfilError) {
              return PerfilErrorView(
                mensaje: state.mensaje,
                onRetry: () {
                  context.read<PerfilBloc>().add(CargarPerfil());
                },
              );
            } else if (state is PerfilLoaded) {
              return PerfilView(
                nombreUsuario: state.nombreUsuario,
                onCerrarSesion: () => _cerrarSesion(context),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
