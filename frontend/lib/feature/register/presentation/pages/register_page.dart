import 'package:design_alma/utils/extensions.dart';
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

  String _parseRegisterError(String? errorMessage, BuildContext context) {
    if (errorMessage == null || errorMessage.isEmpty) {
      return context.l10n.unknownError;
    }

    final e = errorMessage.toLowerCase();

    if (e.contains('email ya existe') ||
        e.contains('este correo ya está registrado')) {
      return context.l10n.emailInUse;
    }

    if (e.contains('contraseña')) {
      return context.l10n.passwordsNotValid;
    }

    if (e.contains('nombre')) {
      return context.l10n.nameNotValid;
    }

    return context.l10n.unknownError;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true, // agrega la flecha de regreso
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                CustomAlert.success(context, context.l10n.registerSuccess);
              } else if (state.status == RegisterStatus.failure) {
                final friendlyMessage =
                    _parseRegisterError(state.errorMessage, context);
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
