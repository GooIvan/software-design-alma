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
            const Text(
              "Lorem ipsum dolor sit amet, sapien etiam, nunc amet dolor ac odio mauris justo.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Read more", style: TextStyle(color: Colors.redAccent)),
                  Icon(Icons.arrow_right_alt, color: Colors.redAccent),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 6,
            )
          ],
        ),
        child: Row(),
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
          onPressed: () {
            // TODO: agregar al carrito
          },
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
