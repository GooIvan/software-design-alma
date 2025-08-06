import 'package:flutter/material.dart';

class PerfilView extends StatelessWidget {
  final String? nombreUsuario;
  final VoidCallback? onCerrarSesion;

  const PerfilView({
    super.key,
    this.nombreUsuario,
    this.onCerrarSesion,
  });

  @override
  Widget build(BuildContext context) {
    final bool estaLogueado = nombreUsuario != null && nombreUsuario!.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        const Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Color.fromARGB(255, 70, 140, 247),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            estaLogueado ? nombreUsuario! : 'Invitado',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 30),

        if (estaLogueado) ...[
          _buildOptionTile(
            context,
            icon: Icons.account_circle,
            title: 'Mi cuenta',
            onTap: () {
            
            },
          ),
          _buildOptionTile(
            context,
            icon: Icons.receipt_long,
            title: 'Mis pedidos',
            onTap: () {
            
            },
          ),
          _buildOptionTile(
            context,
            icon: Icons.settings,
            title: 'Configuración',
            onTap: () {

            },
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: onCerrarSesion,
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ] else ...[
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(Icons.login),
            label: const Text('Iniciar sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            icon: const Icon(Icons.person_add),
            label: const Text('Registrarse'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOptionTile(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
