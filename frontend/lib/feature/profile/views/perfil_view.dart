import 'package:flutter/material.dart';

class PerfilView extends StatelessWidget {
  final String nombreUsuario;
  final VoidCallback onCerrarSesion;

  const PerfilView({
    super.key,
    required this.nombreUsuario,
    required this.onCerrarSesion,
  });

  @override
  Widget build(BuildContext context) {
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
            nombreUsuario,
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
          onTap: onCerrarSesion,
        ),
      ],
    );
  }
}
