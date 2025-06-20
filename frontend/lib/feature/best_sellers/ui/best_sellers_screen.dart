
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/best_sellers_bloc.dart';
import '../logic/best_sellers_event.dart';
import '../logic/best_sellers_state.dart';
import '../data/best_sellers_repository.dart';
import 'widgets/product_tile.dart';

class BestSellersScreen extends StatelessWidget {
  const BestSellersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BestSellersBloc(BestSellersRepository())..add(LoadBestSellers()),
      child: Scaffold(
        appBar: AppBar(title: Text('Más vendidos')),
        body: BlocBuilder<BestSellersBloc, BestSellersState>(
          builder: (context, state) {
            if (state is BestSellersLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BestSellersLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (_, i) => ProductTile(product: state.products[i]),
              );
            } else if (state is BestSellersError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
