import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../feature/cart/data/bloc/cart_bloc.dart';
import '../../data/bloc/category/category_bloc.dart';
import '../../data/bloc/product/product_bloc.dart';
import '../views/products/views_products_error.dart';
import '../views/products/views_products_loading.dart';
import '../../../products/show/presentation/pages/product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide(int totalPages) {
    _timer?.cancel();
    _totalPages = totalPages;
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && _totalPages > 1) {
        _currentPage = (_currentPage + 1) % _totalPages;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _refreshData(BuildContext context) async {
    sl<ProductBloc>().add(LoadProducts());
    sl<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<ProductBloc>()..add(LoadProducts())),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: RefreshIndicator(
          onRefresh: () => _refreshData(context),
          color: Colors.blue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Banner promocional
                _buildPromoBanner(context),
                const SizedBox(height: 24),
                
                // Filtros de categorías
                _buildCategoryFilters(context),
                const SizedBox(height: 32),
                
                // Most Popular section
                _buildMostPopularSection(context),
                const SizedBox(height: 100),
                
                // Special For You section
                _buildSpecialForYouSection(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: screenWidth,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF29B6F6).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '80% OFF',
                    style: TextStyle(
                      color: Color(0xFF29B6F6),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Super Descuento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navegar a productos en descuento
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF29B6F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Shop Now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          return Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.categories.length + 1, // +1 para "All"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryChip('All', true);
                }
                final category = state.categories[index - 1];
                return _buildCategoryChip(category.name, false);
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // TODO: Filtrar productos por categoría
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF29B6F6).withOpacity(0.2),
        checkmarkColor: const Color(0xFF29B6F6),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF29B6F6) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: isSelected ? const Color(0xFF29B6F6) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildMostPopularSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Most Popular',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '🔥',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Ver todos los populares
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFF29B6F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const ViewProductsLoading();
            } else if (state is ProductError) {
              return ViewProductsError(
                title: 'Error al cargar productos',
                onRetry: () {
                  context.read<ProductBloc>().add(LoadProducts());
                },
              );
            } else if (state is ProductLoaded) {
              // Mostrar los productos en carrusel con auto-slide
              final popularProducts = state.products.take(8).toList(); // Más productos para el carrusel
              final totalPages = (popularProducts.length / 2).ceil();
              
              // Iniciar auto-slide cuando tengamos los productos
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _startAutoSlide(totalPages);
              });
              
              return Column(
                children: [
                  Container(
                    height: 280, // Aumentar altura para mejor visualización (era 220)
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: totalPages, // 2 productos por página
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * 2;
                        final endIndex = (startIndex + 2).clamp(0, popularProducts.length);
                        final pageProducts = popularProducts.sublist(startIndex, endIndex);
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: pageProducts.asMap().entries.map((entry) {
                              final index = entry.key;
                              final product = entry.value;
                              return Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: index < pageProducts.length - 1 ? 12 : 0),
                                  child: _buildProductCard(product, isHorizontal: true),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Indicadores de página
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalPages,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index 
                              ? const Color(0xFF29B6F6) 
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildSpecialForYouSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Special For You',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Ver todos
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Color(0xFF29B6F6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const ViewProductsLoading();
            } else if (state is ProductError) {
              return ViewProductsError(
                title: 'Error al cargar productos',
                onRetry: () {
                  context.read<ProductBloc>().add(LoadProducts());
                },
              );
            } else if (state is ProductLoaded) {
              // Mostrar productos en grid 2x2
              final specialProducts = state.products.skip(4).take(4).toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.55, // Más alto (era 0.65) para mejor visualización de imágenes
                  ),
                  itemCount: specialProducts.length,
                  itemBuilder: (context, index) {
                    final product = specialProducts[index];
                    return _buildProductCard(product, isHorizontal: false);
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(dynamic product, {required bool isHorizontal}) {
    return GestureDetector(
      onTap: () {
        // Navegar a detalles del producto como en el código viejo
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              categoryName: product.categoryName ?? 'general',
              id: product.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto con más altura
            Expanded(
              flex: isHorizontal ? 3 : 5, // Mayor proporción para la imagen
              child: Stack(
                children: [
                  // Imagen del producto o placeholder
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              product.imageUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF8F9FA),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          size: isHorizontal ? 35 : 50,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Sin imagen',
                                          style: TextStyle(
                                            fontSize: isHorizontal ? 11 : 13,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: isHorizontal ? 35 : 50,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sin imagen',
                                    style: TextStyle(
                                      fontSize: isHorizontal ? 11 : 13,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  // Botón de favoritos
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Agregar/quitar de favoritos
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Color(0xFF6C7175),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Información del producto
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  Text(
                    product.name ?? 'Producto sin nombre',
                    style: TextStyle(
                      fontSize: isHorizontal ? 13 : 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1D1F),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Precio
                  Row(
                    children: [
                      // Precio actual
                      Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: TextStyle(
                          fontSize: isHorizontal ? 15 : 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF29B6F6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Precio original tachado
                      if (!isHorizontal && product.originalPrice != null && product.originalPrice! > product.price!)
                        Expanded(
                          child: Text(
                            '\$${product.originalPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
