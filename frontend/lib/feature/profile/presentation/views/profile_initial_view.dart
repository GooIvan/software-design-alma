// ignore_for_file: deprecated_member_use

import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../../login/presentation/pages/login_page.dart';
import '../../../register/presentation/pages/register_page.dart';

class ProfileInitialView extends StatelessWidget {
  const ProfileInitialView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color azulPrimary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child:
                      const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // texto invitado
                Text(
                  context.l10n.guest,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                ),
                const SizedBox(height: 30),

                _buildInvitadoCard(
                  context,
                  icon: Icons.info_outline,
                  title: context.l10n.guestMessage1,
                  subtitle: context.l10n.guestMessage2,
                ),

                const SizedBox(height: 20),

                // Botón iniciar sesión
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: Text(context.l10n.signin),
                    style: FilledButton.styleFrom(
                      backgroundColor: azulPrimary,
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
                    label: Text(context.l10n.signup),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      foregroundColor: azulPrimary,
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
    final Color azulPrimary = Theme.of(context).colorScheme.primary;

    return Card(
      color: azulPrimary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: azulPrimary, size: 32),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ),
    );
  }
}
