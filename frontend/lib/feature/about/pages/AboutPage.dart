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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Contributors",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Lista de contribuidores
              Expanded(
                child: ListView(
                  children: contributors
                      .map((contrib) => _contributorCard(contrib))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para cada contribuidor
  Widget _contributorCard(Map<String, String> contrib) {
    return GestureDetector(
      onTap: () => _launchUrl(contrib["github"]!),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Ícono de GitHub
            const Icon(
              Icons
                  .account_circle, // 👈 Aquí puedes poner un ícono de GitHub personalizado
              size: 40,
              color: Colors.black,
            ),
            const SizedBox(width: 12),

            // Nombre
            Text(
              contrib["name"]!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
