import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';
import '../../../../models/user_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutRequested>(_onLogoutRequested);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await repository.fetchProfile();
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(const ProfileError('No se encontró información del usuario'));
      }
    } on TokenExpiredException catch (e) {
      emit(ProfileTokenExpired(e.message));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await repository.logout();
      emit(ProfileLogoutSuccess());
    } catch (e) {
      emit(ProfileError('Error al cerrar sesión: $e'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final updatedUser = await repository.updateProfile(event.user);
      if (updatedUser != null) {
        emit(ProfileUpdated(updatedUser));
        // After update, emit ProfileLoaded to show updated data
        emit(ProfileLoaded(updatedUser));
      } else {
        emit(const ProfileError('No se pudo actualizar el perfil'));
      }
    } on TokenExpiredException catch (e) {
      emit(ProfileTokenExpired(e.message));
    } catch (e) {
      emit(ProfileError('Error al actualizar: $e'));
    }
  }
}
