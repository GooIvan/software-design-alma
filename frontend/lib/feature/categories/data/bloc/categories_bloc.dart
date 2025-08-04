import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../models/category_model.dart';
import '../repositories/categories_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository repository;

  CategoriesBloc(this.repository) : super(CategoriesLoading()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoriesLoading());
      try {
        final categories = await repository.fetchCategories();
        emit(CategoriesLoaded(categories));
      } catch (e) {
        print('Error al cargar categorías: $e');
        emit(const CategoriesError("Error al cargar categorías"));
      }
    });
  }
}
