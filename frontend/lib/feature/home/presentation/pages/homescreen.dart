import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/category/category_bloc.dart';
import '../../data/bloc/product/product_bloc.dart';
import '../views/home_success_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cargando productos...')),
                );
              }
            },
          ),
          BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              // Aquí efectos secundarios para CategoryState
            },
          ),
        ],
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, productState) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                // Aquí construyes la UI con ambos estados
                // OJO: Esta sigue siendo anidación, pero solo para construir UI,
                // sin listeners para no saturar.
                return Text(
                  'Productos: ${productState.toString()}, Categorías: ${categoryState.toString()}',
                );
              },
            );
          },
        ),
      ),
    );
  }
}
