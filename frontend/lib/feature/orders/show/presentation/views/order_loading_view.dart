import 'package:flutter/material.dart';
import '../../../../../widgets/skeleton_loader.dart';

class OrderLoadingView extends StatelessWidget {
  const OrderLoadingView({
    super.key,
  });

  Widget _buildHeaderSkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Número de orden skeleton
              SkeletonLoader(
                width: 180,
                height: 20,
                borderRadius: 8,
              ),
              // Status chip skeleton
              SkeletonLoader(
                width: 80,
                height: 24,
                borderRadius: 20,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // Icono skeleton
              SkeletonLoader(
                width: 16,
                height: 16,
                borderRadius: 4,
              ),
              SizedBox(width: 8),
              // Fecha creada skeleton
              SkeletonLoader(
                width: 150,
                height: 14,
                borderRadius: 8,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              // Icono skeleton
              SkeletonLoader(
                width: 16,
                height: 16,
                borderRadius: 4,
              ),
              SizedBox(width: 8),
              // Fecha actualizada skeleton
              SkeletonLoader(
                width: 160,
                height: 14,
                borderRadius: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemSkeleton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          // Imagen skeleton
          SkeletonLoader(
            width: 80,
            height: 80,
            borderRadius: 8,
          ),
          SizedBox(width: 16),
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del producto skeleton
                SkeletonLoader(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 8,
                ),
                SizedBox(height: 4),
                // Talla skeleton
                SkeletonLoader(
                  width: 80,
                  height: 14,
                  borderRadius: 8,
                ),
                SizedBox(height: 4),
                // Cantidad skeleton
                SkeletonLoader(
                  width: 100,
                  height: 14,
                  borderRadius: 8,
                ),
                SizedBox(height: 4),
                // Precio unitario skeleton
                SkeletonLoader(
                  width: 120,
                  height: 14,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
          // Precio total skeleton
          SkeletonLoader(
            width: 80,
            height: 16,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySkeleton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Resumen de la orden"
          SkeletonLoader(
            width: 160,
            height: 18,
            borderRadius: 8,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // "Total de artículos"
              SkeletonLoader(
                width: 120,
                height: 16,
                borderRadius: 8,
              ),
              // Cantidad
              SkeletonLoader(
                width: 80,
                height: 16,
                borderRadius: 8,
              ),
            ],
          ),
          SizedBox(height: 12),
          // Divider simulation
          SkeletonLoader(
            width: double.infinity,
            height: 1,
            borderRadius: 0,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // "Total:"
              SkeletonLoader(
                width: 60,
                height: 18,
                borderRadius: 8,
              ),
              // Precio total
              SkeletonLoader(
                width: 100,
                height: 20,
                borderRadius: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            _buildHeaderSkeleton(context),
            const SizedBox(height: 20),

            // Título "Artículos" skeleton
            const SkeletonLoader(
              width: 100,
              height: 18,
              borderRadius: 8,
            ),
            const SizedBox(height: 12),

            // Items skeletons (2-3 items)
            _buildItemSkeleton(context),
            _buildItemSkeleton(context),
            _buildItemSkeleton(context),

            const SizedBox(height: 20),

            // Summary skeleton
            _buildSummarySkeleton(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
