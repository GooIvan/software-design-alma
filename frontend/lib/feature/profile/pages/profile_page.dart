import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../bloc/perfil_bloc.dart';
import '../bloc/perfil_event.dart';
import '../bloc/perfil_state.dart';
import '../views/perfil_loading_view.dart';
import '../views/perfil_view.dart';
import '../../../routes/routes.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userEmail');
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'authToken');
    context.read<PerfilBloc>().add(CargarPerfil());
  }

  void _iniciarSesion(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.login);
  }

  void _registrarse(BuildContext context) {
    Navigator.pushNamed(context, AppRoute.register);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PerfilBloc()..add(CargarPerfil()),
      child: Scaffold(
        backgroundColor: Colors.white,
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
                    FilledButton(
                      onPressed: () => _iniciarSesion(context),
                      child: const Text('Iniciar sesión'),
                    ),
                  ],
                ),
              );
            } else if (state is PerfilLoaded) {
              final estaInvitado = state.nombreUsuario.isEmpty;

              if (estaInvitado) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_outline, size: 100, color: Colors.lightBlue),
                        const SizedBox(height: 20),
                        const Text(
                          '¡Bienvenido!',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Estás navegando como invitado. Para disfrutar todas las funciones, inicia sesión o crea una cuenta.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 30),
                        FilledButton(
                          onPressed: () => _iniciarSesion(context),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          ),
                          child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () => _registrarse(context),
                          icon: const Icon(Icons.person_add_alt, color: Colors.lightBlue),
                          label: const Text(
                            'Registrarse',
                            style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return PerfilView(
                  nombreUsuario: state.nombreUsuario,
                  onCerrarSesion: () => _cerrarSesion(context),
                );
              }
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
