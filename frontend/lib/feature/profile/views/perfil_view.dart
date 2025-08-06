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
    const Color azulCielo = Color(0xFF6EC6FF); // Azul cielo claro

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: azulCielo,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                estaLogueado ? nombreUsuario! : 'Invitado',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 30),

            if (estaLogueado) ...[
              _buildOptionTile(
                icon: Icons.account_circle,
                title: 'Mi cuenta',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.receipt_long,
                title: 'Mis pedidos',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.settings,
                title: 'Configuración',
                onTap: () {},
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ] else ...[
              _buildInvitadoCard(
                context,
                icon: Icons.info_outline,
                title: '¿Sabías que puedes acceder a más funciones?',
                subtitle: 'Inicia sesión para ver tu cuenta, pedidos y más.',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                icon: const Icon(Icons.login),
                label: const Text('Iniciar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulCielo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                icon: const Icon(Icons.person_add),
                label: const Text('Registrarse'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: azulCielo),
                  foregroundColor: azulCielo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    const Color azulCielo = Color(0xFF6EC6FF);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: azulCielo),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInvitadoCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    const Color azulCielo = Color(0xFF6EC6FF);

    return Card(
      color: azulCielo.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: azulCielo, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }
}
