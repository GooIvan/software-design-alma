import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Lista de contribuidores
  final List<Map<String, String>> contributors = const [
    {"name": "Iván Madera", "github": "https://github.com/GooIvan"},
    {"name": "Sebastian Cera", "github": "https://github.com/Bastianwx"},
    {"name": "Brian Ortega", "github": "https://github.com/BrianOrtegaa"},
    {"name": "Camilo Cassiani", "github": "https://github.com/Cxmilo2"},
    {"name": "Said Coley", "github": "https://github.com/SaidColey456"},
  ];

  // URL de documentación
  final String documentationUrl =
      "https://gooivan.github.io/software-design-alma/";

  // Método para abrir enlaces
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color azulPrimary = AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          context.l10n.about,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Lista de contribuidores
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.titleDoc,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _launchUrl(documentationUrl),
                      label: Text(
                        context.l10n.see,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                        backgroundColor: azulPrimary,
                        foregroundColor: Colors.white,
                        shadowColor: const Color.fromARGB(255, 119, 124, 133)
                            .withOpacity(0.4),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(azulPrimary),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      context.l10n.contributors,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ...contributors.map((contrib) => _contributorCard(contrib)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contributorCard(Map<String, String> contrib) {
    return _HoverAnimatedCard(
      name: contrib["name"]!,
      url: contrib["github"]!,
      onTap: () => _launchUrl(contrib["github"]!),
    );
  }
}

class _HoverAnimatedCard extends StatefulWidget {
  final String name;
  final String url;
  final VoidCallback onTap;

  const _HoverAnimatedCard({
    required this.name,
    required this.url,
    required this.onTap,
  });

  @override
  State<_HoverAnimatedCard> createState() => _HoverAnimatedCardState();
}

class _HoverAnimatedCardState extends State<_HoverAnimatedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: const EdgeInsets.all(16),
          transform: _isHovered
              ? (() {
                  final matrix = Matrix4.identity();
                  matrix.scale(1.03); // pequeño zoom
                  return matrix;
                })()
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? Colors.blue.shade400 : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Row(
            children: [
              // Icono más estilizado
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _isHovered ? Colors.blue.shade100 : Colors.grey.shade100,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.account_circle_rounded,
                  size: _isHovered ? 46 : 40,
                  color:
                      _isHovered ? Colors.blue.shade600 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: _isHovered ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: _isHovered
                        ? Colors.blue.shade800
                        : Colors.grey.shade900,
                  ),
                  child: Text(widget.name, overflow: TextOverflow.ellipsis),
                ),
              ),
              // Flechita sutil cuando haces hover
              AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
