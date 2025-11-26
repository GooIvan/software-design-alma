import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/favorites_bloc.dart';
import '../views/favorites_error_view.dart';
import '../views/favorites_loading_view.dart';
import '../views/favorites_success_view.dart';
import '../widgets/empty_favorites_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  FavoritesBloc? _bloc;
  bool _firstBuild = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<FavoritesBloc>(context, listen: false);
    if (_bloc != bloc) {
      _bloc = bloc;
      _firstBuild = true;
    }
    // Refresca favoritos cada vez que la vista se muestra
    if (_firstBuild) {
      _firstBuild = false;
      bloc.add(LoadFavorites());
    } else {
      bloc.add(LoadFavorites());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const FavoritesLoadingView();
          }
          // Si la API indica que el usuario no está autenticado, mostramos la pantalla de favoritos vacíos
          if (state is FavoritesUnauthenticated) {
            return EmptyFavoritesPage(
              title: context.l10n.noFavoritesWithLogin1,
              description: context.l10n.noFavoritesWithLogin2,
            );
          }
          if (state is FavoritesError) {
            return FavoritesErrorView(
              message: context.l10n.errorMessageFavorites,
              onRetry: () {
                context.read<FavoritesBloc>().add(LoadFavorites());
              },
            );
          }
          if (state is FavoritesLoaded) {
            return FavoritesSuccessView(
              favorites: state.favorites,
            );
          }
          return const SizedBox(); // fallback
        },
      ),
    );
  }
}
