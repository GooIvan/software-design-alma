import '../widgets/size_selector.dart';
import 'package:flutter/material.dart';
import '../../../../../models/product_model.dart';

class ProductSuccessView extends StatefulWidget {
  final Product product;

  const ProductSuccessView({super.key, required this.product});

  @override
  State<ProductSuccessView> createState() => _ProductSuccessViewState();
}

class _ProductSuccessViewState extends State<ProductSuccessView> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Categoria
            Text(
              widget.product.categoryName,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Nombre
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // Imagen producto
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.network(
                  widget.product.imageUrl,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Talla
            const Text(
              "Seleccionar talla",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizeSelector(sizes: widget.product.sizes),

            const SizedBox(height: 20),

            // Descripcion
            const Text(
              "Descripción",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.product.description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          child: const Text(
            "Add to cart",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
