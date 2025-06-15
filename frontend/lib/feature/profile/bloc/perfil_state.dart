abstract class PerfilState {}

class PerfilInitial extends PerfilState {}

class PerfilLoading extends PerfilState {}

class PerfilLoaded extends PerfilState {
  final String nombreUsuario;
  PerfilLoaded({required this.nombreUsuario});
}

class PerfilError extends PerfilState {
  final String mensaje;
  PerfilError({required this.mensaje});
}
