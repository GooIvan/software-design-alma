import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_model.dart';
import '../../../../widgets/custom_alert.dart';
import '../../../../widgets/product_card.dart';
import '../../../../widgets/square_image_widget.dart';
import 'loadings/home_loading_products_view.dart';
import 'loadings/home_loading_categories_view.dart';
import 'errors/home_error_products_view.dart';
import 'errors/home_error_categories_view.dart';

class HomeSuccessView extends StatelessWidget {
  final List<Product>? products;
  final List<Category>? categories;
  final bool isProductLoading;
  final bool isCategoryLoading;
  final String? productError;
  final String? categoryError;
  final VoidCallback? onRetryProducts;
  final VoidCallback? onRetryCategories;
  final Future<void> Function()? onRefresh;

  const HomeSuccessView({
    super.key,
    this.products,
    this.categories,
    this.isProductLoading = false,
    this.isCategoryLoading = false,
    this.productError,
    this.categoryError,
    this.onRetryProducts,
    this.onRetryCategories,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Sección: "Lo nuevo"
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lo nuevo',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Carrusel de productos nuevos 
        if (productError != null)
          HomeErrorProductsView(
            message: productError!,
            onRetry: onRetryProducts,
          )
        else if (isProductLoading)
          const HomeLoadingProductsView()
        else if (products == null || products!.isEmpty)
          const Center(child: Text('No hay productos'))
        else
          CarouselSlider.builder(
            itemCount: products!.length,
            options: CarouselOptions(
              height: 280,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 0.7,
            ),
            itemBuilder: (context, index, realIdx) {
              return GestureDetector(
                onTap: () {
                  print('Tocaste el producto: "${products![index].name}"');
                  // Aquí puedes agregar la navegación o acción que quieras
                  _showToProduct(context);
                },
                child: ProductCard(product: products![index]),
              );
            },
          ),
          const SizedBox(height: 16),
          // Sección: "Categorias"
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Carrusel de las categorías
          if (categoryError != null)
            HomeErrorCategoriesView(
              message: categoryError!,
              onRetry: onRetryCategories,
            )
          else if (isCategoryLoading)
            const HomeLoadingCategoriesView()
          else if (categories == null || categories!.isEmpty)
            const Center(child: Text('No hay categorías'))
          else
            CarouselSlider.builder(
              itemCount: categories!.length,
              options: CarouselOptions(
                height: 150,
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.4,
              ),
              itemBuilder: (context, index, realIdx) {
                return SquareImageWidget(
                  imageUrl: categories![index].imageUrl,
                  size: 120,
                );
              },
            ),
        ],
      ),
    );
  }

  void _showToProduct(BuildContext context) {
    // Aquí puedes agregar la lógica para añadir el producto al carrito
    CustomAlert.error(context, 'No hay vista del producto');
  }
}
