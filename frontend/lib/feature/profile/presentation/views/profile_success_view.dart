import 'package:design_alma/feature/profile/presentation/widgets/confirm_box.dart';
import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/user_model.dart';
import '../../../about/pages/about_page.dart';
import '../../../configuration/presentation/page/configuration_page.dart';
import '../../../orders/index/presentation/pages/orders_page.dart';

class ProfileSuccessView extends StatelessWidget {
  final User user;
  final VoidCallback? onLogout;
  final Future<void> Function()? onRefresh;

  const ProfileSuccessView({
    super.key,
    required this.user,
    this.onLogout,
    required this.onRefresh,
  });

  Future<void> _onReload() async {
    onRefresh?.call();
    debugPrint("Perfil recargado");
  }

  @override
  Widget build(BuildContext context) {
    final Color azulPrimary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _onReload,
        color: Colors.black,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // Header con avatar y nombre
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: azulPrimary,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${user.name} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Opciones
            _buildOptionTile(
              icon: Icons.account_circle,
              title: context.l10n.myAccount,
              onTap: () {},
            ),
            _buildOptionTile(
              icon: Icons.receipt_long,
              title: context.l10n.myOrders,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersPage(),
                  ),
                );
              },
            ),
            _buildOptionTile(
              icon: Icons.info,
              title: context.l10n.about,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
            _buildOptionTile(
              icon: Icons.settings,
              title: context.l10n.configuration,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfigurationPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón de cerrar sesión
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => confirmBox(context, onConfirm: () {
                    onLogout!();
                  }),
                  icon: const Icon(Icons.logout),
                  label: Text(context.l10n.logout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            // Espacio extra para asegurar scroll
            const SizedBox(height: 50),
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
    const Color azulPrimary = Color(0xFF6EC6FF);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: azulPrimary, size: 24),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
