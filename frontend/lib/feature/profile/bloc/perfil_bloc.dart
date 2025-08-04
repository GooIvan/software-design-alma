import 'package:flutter_bloc/flutter_bloc.dart';
import 'perfil_event.dart';
import 'perfil_state.dart';
import '../../login/services/auth_service.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  final AuthService _authService = AuthService();

  PerfilBloc() : super(PerfilInitial()) {
    on<CargarPerfil>((event, emit) async {
      emit(PerfilLoading());

      try {
        final userData = await _authService.getUserData();
        final nombre = userData['name'];

        if (nombre != null && nombre.isNotEmpty) {
          emit(PerfilLoaded(nombreUsuario: nombre));
        } else {
          emit(PerfilError(mensaje: 'No se pudo cargar el nombre de usuario.'));
        }
      } catch (e) {
        emit(PerfilError(mensaje: 'Error al cargar el perfil.'));
      }
    });
  }
}
