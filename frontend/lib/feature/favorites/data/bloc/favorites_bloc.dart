import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../models/favorite_model.dart';
import 'package:design_alma/feature/favorites/data/repositories/favorites_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository repository;

  FavoritesBloc(this.repository) : super(FavoritesInitial()) {
    on<ResetFavoritesState>((event, emit) async {
      emit(FavoritesInitial());
    });
    on<LoadFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final favorites = await repository.fetchFavorites();
        emit(FavoritesLoaded(favorites));
      } catch (e) {
        print('Error al cargar tus favoritos: $e');
        if (e is UnauthorizedException) {
          emit(const FavoritesUnauthenticated());
        } else {
          emit(const FavoritesError("Error al cargar tus favoritos"));
        }
      }
    });

    on<RefreshFavorites>((event, emit) async {
      emit(FavoritesLoading());
      try {
        final favorites = await repository.fetchFavorites();
        emit(FavoritesLoaded(favorites));
      } catch (e) {
        print('Error al refrescar tus favoritos: $e');
        if (e is UnauthorizedException) {
          emit(const FavoritesUnauthenticated());
        } else {
          emit(const FavoritesError("Error al refrescar tus favoritos"));
        }
      }
    });

    on<AddFavorite>((event, emit) async {
      try {
        await repository.addFavorite(event.productId);
        // Recargar la lista de favoritos después de agregar uno
        final favorites = await repository.fetchFavorites();
        emit(FavoritesLoaded(favorites));
      } catch (e) {
        print('Error al agregar a favoritos: $e');
        if (e is UnauthorizedException) {
          emit(const FavoritesUnauthenticated());
        } else {
          emit(const FavoritesError("Error al agregar a favoritos"));
        }
      }
    });

    on<RemoveFavorite>((event, emit) async {
      try {
        // Necesitamos encontrar el favoriteId basado en el productId
        if (state is FavoritesLoaded) {
          final currentFavorites = (state as FavoritesLoaded).favorites;
          final favoriteToRemove = currentFavorites.firstWhere(
            (fav) => fav.product.id == event.productId,
          );

          await repository.removeFavorite(favoriteToRemove.id);
          // Recargar la lista de favoritos después de eliminar uno
          final favorites = await repository.fetchFavorites();
          emit(FavoritesLoaded(favorites));
        }
      } catch (e) {
        print('Error al eliminar de favoritos: $e');
        if (e is UnauthorizedException) {
          emit(const FavoritesUnauthenticated());
        } else {
          emit(const FavoritesError("Error al eliminar de favoritos"));
        }
      }
    });
  }
}
