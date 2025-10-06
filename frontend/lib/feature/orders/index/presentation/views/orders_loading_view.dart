import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class OrdersLoadingView extends StatelessWidget {
  const OrdersLoadingView({
    super.key,
  });

  Widget _buildFilterChipSkeleton(double width, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[300] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.grey[400]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: SkeletonLoader(
        width: width,
        height: 14,
        borderRadius: 4,
      ),
    );
  }

  Widget _buildSortChipSkeleton(double width, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[300] : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.grey[400]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SkeletonLoader(
            width: 16,
            height: 16,
            borderRadius: 4,
          ),
          const SizedBox(width: 6),
          SkeletonLoader(
            width: width - 22, // Restar el ancho del icono + spacing
            height: 12,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filtros y ordenamiento skeleton
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtros por estado skeleton
              Row(
                children: [
                  SkeletonLoader(
                    width: 18,
                    height: 18,
                    borderRadius: 4,
                  ),
                  const SizedBox(width: 8),
                  const SkeletonLoader(
                    width: 60,
                    height: 14,
                    borderRadius: 4,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Chips de filtro skeleton
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChipSkeleton(60, true), // "Todas" seleccionado
                    const SizedBox(width: 8),
                    _buildFilterChipSkeleton(70, false), // "Pagadas"
                    const SizedBox(width: 8),
                    _buildFilterChipSkeleton(80, false), // "Pendientes"
                    const SizedBox(width: 8),
                    _buildFilterChipSkeleton(85, false), // "Canceladas"
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ordenamiento skeleton
              Row(
                children: [
                  SkeletonLoader(
                    width: 18,
                    height: 18,
                    borderRadius: 4,
                  ),
                  const SizedBox(width: 8),
                  const SkeletonLoader(
                    width: 80,
                    height: 14,
                    borderRadius: 4,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Chips de ordenamiento skeleton
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSortChipSkeleton(
                        110, true), // "Más recientes" seleccionado
                    const SizedBox(width: 8),
                    _buildSortChipSkeleton(100, false), // "Más antiguas"
                    const SizedBox(width: 8),
                    _buildSortChipSkeleton(90, false), // "Mayor valor"
                    const SizedBox(width: 8),
                    _buildSortChipSkeleton(90, false), // "Menor valor"
                  ],
                ),
              ),
            ],
          ),
        ),

        // Contador de resultados skeleton
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const SkeletonLoader(
                width: 120,
                height: 12,
                borderRadius: 4,
              ),
            ],
          ),
        ),

        // Lista de órdenes skeleton
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount:
                4, // cantidad de placeholders reducida por el espacio de filtros
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
        ),
      ],
    );
  }
}
