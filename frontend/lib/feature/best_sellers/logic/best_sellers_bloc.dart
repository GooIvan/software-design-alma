
import 'package:flutter_bloc/flutter_bloc.dart';
import 'best_sellers_event.dart';
import 'best_sellers_state.dart';
import '../data/best_sellers_repository.dart';

class BestSellersBloc extends Bloc<BestSellersEvent, BestSellersState> {
  final BestSellersRepository repository;

  BestSellersBloc(this.repository) : super(BestSellersInitial()) {
    on<LoadBestSellers>((event, emit) async {
      emit(BestSellersLoading());
      try {
        final products = await repository.fetchBestSellers();
        emit(BestSellersLoaded(products));
      } catch (e) {
        emit(BestSellersError(e.toString()));
      }
    });
  }
}
