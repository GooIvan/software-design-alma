import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/bloc/register_bloc.dart';

class RegisterInitialView extends StatefulWidget {
  const RegisterInitialView({super.key});

  @override
  State<RegisterInitialView> createState() => _RegisterInitialViewState();
}

class _RegisterInitialViewState extends State<RegisterInitialView> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para inputs
  final _emailController = TextEditingController(text: 'user@test.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _passwordConfirmController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController(text: 'Test');
  final _lastNameController = TextEditingController(text: 'User');
  final _cityController = TextEditingController(text: 'Bogota');
  final _phoneController = TextEditingController(text: '3001234567');
  final _addressController = TextEditingController(text: 'Calle 123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
            RegisterSubmitted(
              email: _emailController.text,
              password: _passwordController.text,
              passwordConfirmation: _passwordConfirmController.text,
              name: _nameController.text,
              lastName: _lastNameController.text,
              city: _cityController.text,
              phone: _phoneController.text,
              address: _addressController.text,
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
            TextFormField(
              controller: _passwordConfirmController,
              decoration:
                  const InputDecoration(labelText: 'Confirmar Contraseña'),
              obscureText: true,
              validator: (v) =>
                  v != _passwordController.text ? 'No coincide' : null,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Ingrese su nombre' : null,
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Ciudad'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onRegisterPressed(context),
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
