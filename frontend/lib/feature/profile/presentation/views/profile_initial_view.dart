// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../register/presentation/pages/register_page.dart';

class ProfileInitialView extends StatelessWidget {
  const ProfileInitialView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const Color azulCielo = Color(0xFF6EC6FF);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: azulCielo,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // texto invitado
                Text(
                  'Invitado',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 30),

                _buildInvitadoCard(
                  context,
                  icon: Icons.info_outline,
                  title: '¿Sabías que puedes acceder a más funciones?',
                  subtitle: 'Inicia sesión para ver tu cuenta, pedidos y más.',
                ),

                const SizedBox(height: 20),

                // Botón iniciar sesión
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => {},
                    icon: const Icon(Icons.login),
                    label: const Text('Iniciar sesión'),
                    style: FilledButton.styleFrom(
                      backgroundColor: azulCielo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 14,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón registrarse
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Registrarse'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: azulCielo),
                      foregroundColor: azulCielo,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 14,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: azulCielo, size: 32),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
              ),
        ),
      ),
    );
  }
}
