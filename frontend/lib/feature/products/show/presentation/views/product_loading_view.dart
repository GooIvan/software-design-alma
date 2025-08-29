import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class ProductLoadingView extends StatelessWidget {
  const ProductLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Categoria (placeholder)
            SkeletonLoader(width: 120, height: 20),

            SizedBox(height: 12),

            // Nombre (placeholder)
            SkeletonLoader(width: 220, height: 28),

            SizedBox(height: 20),

            // Imagen producto
            Center(
              child: SkeletonLoader(
                width: double.infinity,
                height: 400,
                borderRadius: 26,
              ),
            ),

            SizedBox(height: 20),

            // Talla
            SkeletonLoader(width: 160, height: 22),
            SizedBox(height: 8),

            // Botones de talla (3 simulados)
            Row(
              children: [
                SkeletonLoader(width: 60, height: 40, borderRadius: 12),
                SizedBox(width: 12),
                SkeletonLoader(width: 60, height: 40, borderRadius: 12),
                SizedBox(width: 12),
                SkeletonLoader(width: 60, height: 40, borderRadius: 12),
              ],
            ),

            SizedBox(height: 20),

            // descripcion en 3 lineas
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 150, height: 18, borderRadius: 8),
                SizedBox(height: 10),
                SkeletonLoader(
                    width: double.infinity, height: 18, borderRadius: 8),
                SizedBox(height: 6),
                SkeletonLoader(
                    width: double.infinity, height: 18, borderRadius: 8),
              ],
            ),

            SizedBox(height: 40),
          ],
        ),
      ),

      // Botones fijos abajo
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 90,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: SkeletonLoader(
                    width: double.infinity, height: 56, borderRadius: 40),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SkeletonLoader(
                    width: double.infinity, height: 56, borderRadius: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
