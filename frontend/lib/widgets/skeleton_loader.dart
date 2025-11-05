import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;
  final ShimmerDirection direction;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(seconds: 2),
    this.direction = ShimmerDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colores adaptativos según el tema
    final Color adaptiveBaseColor = baseColor ??
        (isDarkMode
            ? const Color(0xFF1A2B3A) // Azul turquesa oscuro para modo oscuro
            : Colors.grey[300]!); // Gris claro para modo claro

    final Color adaptiveHighlightColor = highlightColor ??
        (isDarkMode
            ? const Color(
                0xFF243545) // Azul turquesa más claro para modo oscuro
            : Colors.grey[100]!); // Gris muy claro para modo claro

    return Shimmer.fromColors(
      baseColor: adaptiveBaseColor,
      highlightColor: adaptiveHighlightColor,
      period: period,
      direction: direction,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: adaptiveBaseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// Clase auxiliar para crear skeletons temáticos predefinidos
class SkeletonThemes {
  // Tema principal (usa colores adaptativos automáticos)
  static SkeletonLoader adaptive({
    required double width,
    required double height,
    double borderRadius = 8,
    Duration period = const Duration(seconds: 2),
  }) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
      period: period,
    );
  }

  // Tema azul
  static SkeletonLoader blue({
    required double width,
    required double height,
    double borderRadius = 8,
    Duration period = const Duration(seconds: 2),
  }) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
      baseColor: Colors.blue[100],
      highlightColor: Colors.blue[50],
      period: period,
    );
  }

  // Tema verde
  static SkeletonLoader green({
    required double width,
    required double height,
    double borderRadius = 8,
    Duration period = const Duration(seconds: 2),
  }) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
      baseColor: Colors.green[100],
      highlightColor: Colors.green[50],
      period: period,
    );
  }

  // Tema personalizado con colores específicos
  static SkeletonLoader custom({
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
    double borderRadius = 8,
    Duration period = const Duration(seconds: 2),
    ShimmerDirection direction = ShimmerDirection.ltr,
  }) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: period,
      direction: direction,
    );
  }
}
