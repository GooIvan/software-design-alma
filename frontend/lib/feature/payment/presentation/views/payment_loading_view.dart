import 'package:flutter/material.dart';
import '../../../../widgets/skeleton_loader.dart';

class PaymentLoadingView extends StatelessWidget {
  const PaymentLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton para resumen de orden
          _buildOrderSummaryskeleton(context),
          const SizedBox(height: 20),

          // Skeleton para formulario de tarjeta
          _buildPaymentFormSkeleton(context),
          const SizedBox(height: 32),

          // Skeleton para botón de pago
          _buildPaymentButtonSkeleton(context),
          const SizedBox(height: 20),

          // Skeleton para estado de pago
          _buildPaymentStatusSkeleton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryskeleton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del resumen
          const SkeletonLoader(
            width: 150,
            height: 24,
            borderRadius: 8,
          ),
          const SizedBox(height: 16),

          // Items de la orden
          ...List.generate(
              3,
              (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // Imagen del producto
                        SkeletonLoader(
                          width: 50,
                          height: 50,
                          borderRadius: 8,
                        ),
                        SizedBox(width: 12),

                        // Información del producto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonLoader(
                                width: double.infinity,
                                height: 16,
                                borderRadius: 4,
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SkeletonLoader(
                                    width: 60,
                                    height: 14,
                                    borderRadius: 4,
                                  ),
                                  SkeletonLoader(
                                    width: 80,
                                    height: 16,
                                    borderRadius: 4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

          Divider(
            height: 24,
            color: Theme.of(context).dividerColor,
          ),

          // Total
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader(
                width: 60,
                height: 20,
                borderRadius: 4,
              ),
              SkeletonLoader(
                width: 100,
                height: 24,
                borderRadius: 4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentFormSkeleton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del formulario
          SkeletonLoader(
            width: 200,
            height: 24,
            borderRadius: 8,
          ),
          SizedBox(height: 20),

          // Campo número de tarjeta
          SkeletonLoader(
            width: double.infinity,
            height: 50,
            borderRadius: 12,
          ),
          SizedBox(height: 16),

          // Campos fecha y CVV
          Row(
            children: [
              Expanded(
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 50,
                  borderRadius: 12,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 50,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Campo nombre del titular
          SkeletonLoader(
            width: double.infinity,
            height: 50,
            borderRadius: 12,
          ),
          SizedBox(height: 16),

          // Campo email
          SkeletonLoader(
            width: double.infinity,
            height: 50,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButtonSkeleton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
      ),
      child: const SkeletonLoader(
        width: double.infinity,
        height: 56,
        borderRadius: 16,
      ),
    );
  }

  Widget _buildPaymentStatusSkeleton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(
            width: 120,
            height: 20,
            borderRadius: 4,
          ),
          SizedBox(height: 12),
          SkeletonLoader(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          SizedBox(height: 8),
          SkeletonLoader(
            width: 200,
            height: 16,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}
