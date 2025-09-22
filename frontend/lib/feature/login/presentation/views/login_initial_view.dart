import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bloc/login_bloc.dart';

class LoginInitialView extends StatefulWidget {
  const LoginInitialView({super.key});

  @override
  State<LoginInitialView> createState() => _LoginInitialViewState();
}

class _LoginInitialViewState extends State<LoginInitialView> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para inputs
  final _emailController = TextEditingController(text: 'user@test.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
            LoginSubmitted(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Ingrese su email' : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              validator: (v) =>
                  v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onLoginPressed(context),
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
