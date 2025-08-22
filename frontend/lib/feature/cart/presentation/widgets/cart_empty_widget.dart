import 'package:flutter/material.dart';

class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        // Por si en algún dispositivo hay overflow
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono con sombra y animación de rebote
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                tween: Tween(begin: 0.8, end: 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[200]!, Colors.grey[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Título
              Text(
                'Tu carrito está vacío',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtítulo
              Text(
                'Agrega algunos productos para comenzar tu compra',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // Botón con degradado
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Colors.black87, Colors.black54],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Comenzar a Comprar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
