
import 'package:equatable/equatable.dart';

abstract class BestSellersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBestSellers extends BestSellersEvent {}
