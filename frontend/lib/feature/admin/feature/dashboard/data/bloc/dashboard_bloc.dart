import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../models/dashboard_model.dart';
import '../repository/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository repository;
  DashboardBloc(this.repository) : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final dashboard = await repository.fetchDashboard();
        emit(DashboardLoaded(dashboard));
      } catch (e) {
        print('Error al cargar el dashboard: $e');
        emit(const DashboardError("Error al cargar el dashboard"));
      }
    });

    on<RefreshDashboard>((event, emit) async {
      emit(DashboardLoading());
      try {
        final dashboard = await repository.fetchDashboard();
        emit(DashboardLoaded(dashboard));
      } catch (e) {
        print('Error al refrescar el dashboard: $e');
        emit(const DashboardError("Error al refrescar el dashboard"));
      }
    });
  }
}
