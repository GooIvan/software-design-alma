import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/main_scaffold.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../widgets/custom_alert.dart';
import '../../data/bloc/register_bloc.dart';
import '../views/register_initial_view.dart';
import '../views/register_loading_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  String _parseRegisterError(String? errorMessage) {
    if (errorMessage == null || errorMessage.isEmpty) {
      return 'Error desconocido, intenta nuevamente.';
    }

    final e = errorMessage.toLowerCase();

    if (e.contains('email ya existe') ||
        e.contains('este correo ya está registrado')) {
      return 'El correo ya está en uso. Intenta con otro.';
    }

    if (e.contains('contraseña')) {
      return 'La contraseña no cumple los requisitos.';
    }

    if (e.contains('nombre')) {
      return 'Debes ingresar un nombre válido.';
    }

    return errorMessage; // mostrar el original si no coincide
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // agrega la flecha de regreso
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state.status == RegisterStatus.success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainScaffold(initialIndex: 3),
                  ),
                );
                CustomAlert.success(context, 'Registro exitoso');
              } else if (state.status == RegisterStatus.failure) {
                final friendlyMessage = _parseRegisterError(state.errorMessage);
                CustomAlert.error(context, friendlyMessage);
              }
            },
            builder: (context, state) {
              if (state.status == RegisterStatus.loading) {
                return const RegisterLoadingView();
              }
              return const RegisterInitialView();
            },
          ),
        ),
      ),
    );
  }
}
