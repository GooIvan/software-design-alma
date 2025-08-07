import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../models/category_model.dart';
import '../../repositories/home_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final HomeRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await repository.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        print('Error al cargar categorías: $e');
        emit(const CategoryError("Error al cargar categorías"));
      }
    });

    on<RefreshCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        // Usar el método refresh que ignora el caché
        final categories = await repository.refreshCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        print('Error al refrescar categorías: $e');
        emit(const CategoryError("Error al refrescar categorías"));
      }
    });
  }
}
