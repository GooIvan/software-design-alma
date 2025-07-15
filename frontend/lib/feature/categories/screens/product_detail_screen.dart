import 'package:flutter/material.dart';
import '../models/category_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final CategoryModel category;

  const ProductDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.blue[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Usamos Align para centrar la imagen
              Align(
                alignment: Alignment.center, // Centra la imagen en el centro de la pantalla
                child: Image.network(
                  category.imageUrl,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 48),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                category.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                category.descripcion ?? 'Descripción no disponible',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                category.precio != null
                    ? '\$${category.precio.toStringAsFixed(2)}'
                    : 'Precio no disponible',
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
