// ignore_for_file: deprecated_member_use

import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../../login/presentation/pages/login_page.dart';
import '../../../register/presentation/pages/register_page.dart';
import '../../../configuration/presentation/page/configuration_page.dart';

class ProfileInitialView extends StatelessWidget {
  const ProfileInitialView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color azulPrimary = Colors.blue;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: azulPrimary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // "Invitado"
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
                      side: BorderSide(color: azulPrimary),
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

                const SizedBox(height: 20),

                // Botón configuración
                Container(
                  decoration: BoxDecoration(
                    color: azulPrimary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: azulPrimary.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ConfigurationPage()),
                      );
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: azulPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: azulPrimary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      context.l10n.configuration,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                    ),
                    subtitle: Text(
                      context.l10n.configurationSubtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: azulPrimary.withOpacity(0.6),
                      size: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
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

  Widget _buildInvitadoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
