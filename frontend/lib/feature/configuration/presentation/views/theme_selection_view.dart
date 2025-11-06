import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../widgets/custom_alert.dart';

class ThemeSelectionView extends StatelessWidget {
  const ThemeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            centerTitle: true,
            title: Text(
              context.l10n.appTheme,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lista de temas
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildThemeOption(
                          context: context,
                          themeMode: AppThemeMode.light,
                          icon: FeatherIcons.sun,
                          themeName: context.l10n.lightTheme,
                          themeDescription: context.l10n.lightThemeDescription,
                          isFirst: true,
                          themeProvider: themeProvider,
                        ),
                        _buildDivider(context),
                        _buildThemeOption(
                          context: context,
                          themeMode: AppThemeMode.dark,
                          icon: FeatherIcons.moon,
                          themeName: context.l10n.darkTheme,
                          themeDescription: context.l10n.darkThemeDescription,
                          themeProvider: themeProvider,
                        ),
                        _buildDivider(context),
                        _buildThemeOption(
                          context: context,
                          themeMode: AppThemeMode.system,
                          icon: FeatherIcons.smartphone,
                          themeName: context.l10n.systemTheme,
                          themeDescription: context.l10n.systemThemeDescription,
                          isLast: true,
                          themeProvider: themeProvider,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Información adicional
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF29B6F6).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF29B6F6).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          FeatherIcons.info,
                          size: 20,
                          color: Color(0xFF29B6F6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            context.l10n.restartAppToApplyLanguage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required AppThemeMode themeMode,
    required IconData icon,
    required String themeName,
    required String themeDescription,
    required ThemeProvider themeProvider,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = themeProvider.themeMode == themeMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await themeProvider.setThemeMode(themeMode);

          if (context.mounted) {
            Navigator.of(context).pop();
            CustomAlert.success(context, context.l10n.themeChanged);
          }
        },
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Icono del tema
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF29B6F6).withOpacity(0.1)
                      : Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF29B6F6)
                        : Theme.of(context).dividerColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? const Color(0xFF29B6F6)
                      : Theme.of(context).iconTheme.color,
                  size: 20,
                ),
              ),

              const SizedBox(width: 16),

              // Información del tema
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      themeName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF29B6F6)
                            : Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      themeDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Indicador de selección
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF29B6F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
