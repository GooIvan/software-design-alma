import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/perfil_bloc.dart';
import '../bloc/perfil_event.dart';
import '../bloc/perfil_state.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PerfilBloc()..add(CargarPerfil()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          backgroundColor: Color.fromARGB(255, 70, 140, 247),
        ),
        body: BlocBuilder<PerfilBloc, PerfilState>(
          builder: (context, state) {
            if (state is PerfilLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PerfilError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.mensaje,
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PerfilBloc>().add(CargarPerfil());
                      },
                      child: const Text("Reintentar"),
                    ),
                  ],
                ),
              );
            } else if (state is PerfilLoaded) {
              return ListView(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color.fromARGB(255, 70, 140, 247),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      state.nombreUsuario,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Divider(height: 40, thickness: 1.5),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Mi cuenta'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text('Mis pedidos'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Configuración'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar sesión'),
                    onTap: () {},
                  ),
                ],
              );
            }

            // Estado inicial u otro no contemplado
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
