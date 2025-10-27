import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../widgets/custom_alert.dart';

class LanguageSelectionView extends StatelessWidget {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            centerTitle: true,
          ),
          backgroundColor: const Color(0xFFf8f9fa),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lista de idiomas
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        _buildLanguageOption(
                          context: context,
                          languageCode: 'es',
                          languageName: 'Español',
                          countryName: 'España',
                          flagEmoji: '🇪🇸',
                          isFirst: true,
                          languageProvider: languageProvider,
                        ),
                        _buildDivider(),
                        _buildLanguageOption(
                          context: context,
                          languageCode: 'en',
                          languageName: 'English',
                          countryName: 'United States',
                          flagEmoji: '🇺🇸',
                          languageProvider: languageProvider,
                        ),
                        _buildDivider(),
                        _buildLanguageOption(
                          context: context,
                          languageCode: 'fr',
                          languageName: 'Français',
                          countryName: 'France',
                          flagEmoji: '🇫🇷',
                          isLast: true,
                          languageProvider: languageProvider,
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
                              color: Colors.grey.shade700,
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

  Widget _buildLanguageOption({
    required BuildContext context,
    required String languageCode,
    required String languageName,
    required String countryName,
    required String flagEmoji,
    required LanguageProvider languageProvider,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = languageProvider.locale.languageCode == languageCode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await languageProvider.setLocale(languageCode);

          if (context.mounted) {
            Navigator.of(context).pop();

            String message;
            switch (languageCode) {
              case 'es':
                message = 'Idioma cambiado exitosamente';
                break;
              case 'fr':
                message = 'Langue changée avec succès';
                break;
              default:
                message = 'Language changed successfully';
            }
            CustomAlert.success(context, message);
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
              // Bandera
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CountryFlag.fromCountryCode(
                    languageCode == 'es'
                        ? 'ES'
                        : languageCode == 'fr'
                            ? 'FR'
                            : 'US',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Información del idioma
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF29B6F6)
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      countryName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
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
                      color: Colors.grey.shade300,
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

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: Colors.grey.shade200,
    );
  }
}
