import '../../../../core/di/service_locator.dart';
import '../data/bloc/order_bloc.dart';
import '../data/repositories/order_repository.dart';

void initOrderModule() {
  // Registro del Repository
  sl.registerLazySingleton<OrderRepository>(() => OrderRepository());

  // Registro del Bloc
  sl.registerLazySingleton<OrderBloc>(
    () => OrderBloc(sl<OrderRepository>()),
  );
}
