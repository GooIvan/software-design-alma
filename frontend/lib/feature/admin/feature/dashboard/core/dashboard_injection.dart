import '../../../../../core/di/service_locator.dart';
import '../data/bloc/dashboard_bloc.dart';
import '../data/repository/dashboard_repository.dart';

void initDashboardModule() {
  // Registro del Repository
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepository());

  // Registro del Bloc
  sl.registerLazySingleton<DashboardBloc>(
    () => DashboardBloc(sl<DashboardRepository>()),
  );
}
