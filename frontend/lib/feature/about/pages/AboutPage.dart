import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca de"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Contribuidores",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Lista de contribuidores
              Expanded(
                child: ListView(
                  children: [
                    ...contributors
                        .map((contrib) => _contributorCard(contrib))
                        .toList(),

                    const SizedBox(height: 30),

                    // Apartado de documentación
                    const Text(
                      "Documentación del Proyecto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: () => _launchUrl(documentationUrl),
                      icon: const Icon(Icons.book),
                      label: const Text("Ver Documentación"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
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
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.blue.shade50 : Colors.white,
            border: Border.all(
                color: _isHovered ? Colors.blue : Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                Icons.account_circle,
                size: _isHovered ? 45 : 40,
                color: _isHovered ? Colors.blue : Colors.black,
              ),
              const SizedBox(width: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: _isHovered ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? Colors.blue : Colors.black,
                ),
                child: Text(widget.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
