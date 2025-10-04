import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class OrdersLoadingView extends StatelessWidget {
  const OrdersLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 6, // cantidad de placeholders
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const IntrinsicHeight(
              child: Row(
                children: [
                  // Borde lateral skeleton (simula el estado)
                  SkeletonLoader(
                    width: 6,
                    height: 140,
                    borderRadius: 12,
                  ),
                  // Contenido de la tarjeta
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Número de orden skeleton
                                SkeletonLoader(
                                  width: 200,
                                  height: 16,
                                  borderRadius: 8,
                                ),
                                SizedBox(height: 14),
                                // Cantidad de artículos skeleton
                                SkeletonLoader(
                                  width: 80,
                                  height: 14,
                                  borderRadius: 8,
                                ),
                                SizedBox(height: 10),
                                // Total skeleton (más ancho para simular precio)
                                SkeletonLoader(
                                  width: 100,
                                  height: 18,
                                  borderRadius: 8,
                                ),
                                SizedBox(height: 14),
                                // Fecha skeleton
                                SkeletonLoader(
                                  width: 90,
                                  height: 12,
                                  borderRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          // Icono de flecha skeleton
                          SkeletonLoader(
                            width: 24,
                            height: 24,
                            borderRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
