import 'package:design_alma/feature/profile/presentation/widgets/confirm_box.dart';
import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/user_model.dart';
import '../../../about/pages/about_page.dart';
import '../../../configuration/presentation/page/configuration_page.dart';
import '../../../orders/index/presentation/pages/orders_page.dart';
import '../../data/bloc/profile_bloc.dart';
import '../pages/edit_profile_page.dart';

class ProfileSuccessView extends StatefulWidget {
  final User user;
  final VoidCallback? onLogout;
  final Future<void> Function()? onRefresh;

  const ProfileSuccessView({
    super.key,
    required this.user,
    this.onLogout,
    required this.onRefresh,
  });

  @override
  State<ProfileSuccessView> createState() => _ProfileSuccessViewState();
}

class _ProfileSuccessViewState extends State<ProfileSuccessView> {
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadPhotoUrl();
  }

  Future<void> _loadPhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final photoUrl = prefs.getString('user_photo_url');
    if (photoUrl != null && photoUrl.isNotEmpty) {
      setState(() {
        _photoUrl = photoUrl;
      });
    }
  }

  Future<void> _onReload() async {
    widget.onRefresh?.call();
    debugPrint("Perfil recargado");
  }

  @override
  Widget build(BuildContext context) {
    final Color azulPrimary = Theme.of(context).colorScheme.primary;
    final profileBloc = context.read<ProfileBloc>();

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
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: azulPrimary,
                    backgroundImage: _photoUrl != null && _photoUrl!.isNotEmpty
                        ? NetworkImage(_photoUrl!)
                        : null,
                    child: _photoUrl == null || _photoUrl!.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: profileBloc,
                              child: EditProfilePage(user: widget.user),
                            ),
                          ),
                        );
                        if (result == true) {
                          _onReload();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: azulPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${widget.user.name} ${widget.user.lastName}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.displayLarge?.color,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Opciones
            _buildOptionTile(
              context: context,
              icon: Icons.account_circle,
              title: context.l10n.myAccount,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: profileBloc,
                      child: EditProfilePage(user: widget.user),
                    ),
                  ),
                );
                if (result == true) {
                  _onReload();
                }
              },
            ),
            _buildOptionTile(
              context: context,
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
              context: context,
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
              context: context,
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
                    widget.onLogout!();
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
    required BuildContext context,
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
