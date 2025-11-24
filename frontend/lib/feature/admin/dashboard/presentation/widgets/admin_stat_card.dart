import 'package:flutter/material.dart';

class AdminStatCard extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const AdminStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor = Colors.pink,
    this.iconBackground = const Color(0xFFF7E6F4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Valor y texto
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$value",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Icono con fondo redondeado
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
