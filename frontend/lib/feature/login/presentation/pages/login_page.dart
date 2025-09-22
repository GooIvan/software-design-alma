import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/main_scaffold.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../widgets/custom_alert.dart';
import '../../data/bloc/login_bloc.dart';
import '../views/login_initial_view.dart';
import '../views/login_loading_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  String _parseLoginError(String? errorMessage) {
    if (errorMessage == null || errorMessage.isEmpty) {
      return 'Error desconocido, intenta nuevamente.';
    }

    // Intentar parsear JSON si viene en formato JSON
    try {
      if (errorMessage.contains('"message"')) {
        // Extraer solo el mensaje del JSON
        final regex = RegExp(r'"message":"([^"]*)"');
        final match = regex.firstMatch(errorMessage);
        if (match != null) {
          final extractedMessage = match.group(1) ?? errorMessage;

          // Ahora verificar el mensaje extraído
          final e = extractedMessage.toLowerCase();
          if (e.contains('invalid email or password')) {
            return 'Correo o contraseña incorrectos, intenta nuevamente.';
          }

          return extractedMessage;
        }
      }
    } catch (e) {
      print('❌ Error al parsear JSON: $e');
    }

    // Si no es JSON, verificar directamente
    final e = errorMessage.toLowerCase();
    if (e.contains('invalid email or password') ||
        e.contains('correo o contraseña incorrectos')) {
      return 'Correo o contraseña incorrectos, intenta nuevamente.';
    }

    return errorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<LoginBloc>(),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true, // agrega la flecha de regreso
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: Center(
                child: BlocConsumer<LoginBloc, LoginState>(
              listener: (BuildContext context, LoginState state) {
                if (state is LoginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainScaffold(initialIndex: 3),
                    ),
                  );
                  CustomAlert.success(context, 'Inicio de sesión exitoso');
                } else if (state is LoginFailure) {
                  final friendlyMessage = _parseLoginError(state.message);
                  CustomAlert.error(context, friendlyMessage);
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const LoginLoadingView();
                }
                return const LoginInitialView();
              },
            ))));
  }
}
