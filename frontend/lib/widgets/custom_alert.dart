import 'package:flutter/material.dart';

// Enum para los tipos de alerta
enum AlertType {
  success,
  error,
  warning,
  info,
}

class CustomAlert {
  // Función estática para mostrar alertas
  static void show(BuildContext context, String message, AlertType type) {
    Color backgroundColor;
    IconData icon;
    
    switch (type) {
      case AlertType.success:
        backgroundColor = const Color(0xFF28A745); // Verde Bootstrap
        icon = Icons.check_circle_outline;
        break;
      case AlertType.error:
        backgroundColor = const Color(0xFFDC3545); // Rojo Bootstrap
        icon = Icons.error_outline;
        break;
      case AlertType.warning:
        backgroundColor = const Color(0xFFFFC107); // Amarillo Bootstrap
        icon = Icons.warning_amber_outlined;
        break;
      case AlertType.info:
        backgroundColor = const Color(0xFF17A2B8); // Azul Bootstrap
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
      ),
    );
  }

  // Métodos de conveniencia para cada tipo
  static void success(BuildContext context, String message) {
    show(context, message, AlertType.success);
  }

  static void error(BuildContext context, String message) {
    show(context, message, AlertType.error);
  }

  static void warning(BuildContext context, String message) {
    show(context, message, AlertType.warning);
  }

  static void info(BuildContext context, String message) {
    show(context, message, AlertType.info);
  }
}
