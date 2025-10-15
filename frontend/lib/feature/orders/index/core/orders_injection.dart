import '../../../../core/di/service_locator.dart';
import '../data/bloc/orders_bloc.dart';
import '../data/repositories/orders_repository.dart';

void initOrdersModule() {
  // Registro del Repository
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepository());

  // Registro del Bloc
  sl.registerLazySingleton<OrdersBloc>(
    () => OrdersBloc(sl<OrdersRepository>())..add(LoadOrders()),
  );
}
