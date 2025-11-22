part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class RefreshFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final int productId;

  const AddFavorite(this.productId);

  @override
  List<Object> get props => [productId];
}

class RemoveFavorite extends FavoritesEvent {
  final int productId;

  const RemoveFavorite(this.productId);

  @override
  List<Object> get props => [productId];
}
