import 'package:flutter_bloc/flutter_bloc.dart';
import 'perfil_event.dart';
import 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  PerfilBloc() : super(PerfilInitial()) {
    on<CargarPerfil>((event, emit) async {
      emit(PerfilLoading());

      try {
        // Simular carga
        await Future.delayed(const Duration(seconds: 1));
        const nombre = 'Juan Pérez';
        emit(PerfilLoaded(nombreUsuario: nombre));
      } catch (_) {
        emit(PerfilError(mensaje: 'No se pudo cargar el perfil'));
      }
    });
  }
}
