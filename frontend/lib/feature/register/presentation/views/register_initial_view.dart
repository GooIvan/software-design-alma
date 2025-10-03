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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _obscurePassword = true; // para controlar el ojito
  bool _obscurePasswordConfirm = true; // para controlar el ojito

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
    const azulCielo = Color.fromARGB(255, 26, 162, 253);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Título
                  const Text(
                    '¡Bienvenido a Diseños Alma!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Crea una cuenta para comenzar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Input name
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Introduce tu nombre',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error (mantiene radius)
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando está enfocado y hay error
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese su nombre' : null,
                  ),

                  const SizedBox(height: 20),

                  // Input last name
                  TextFormField(
                    controller: _lastNameController,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Introduce tu apellido',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error (mantiene radius)
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando está enfocado y hay error
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese su apellido' : null,
                  ),

                  const SizedBox(height: 20),

                  // Input city
                  TextFormField(
                    controller: _cityController,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Introduce tu ciudad',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.location_city,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error (mantiene radius)
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando está enfocado y hay error
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese su ciudad' : null,
                  ),

                  const SizedBox(height: 20),

                  // Input Address
                  TextFormField(
                    controller: _addressController,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Introduce tu dirección',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.home,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error (mantiene radius)
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando está enfocado y hay error
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese su dirección' : null,
                  ),

                  const SizedBox(height: 20),

                  // Input phone
                  TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Introduce tu teléfono',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.phone,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error (mantiene radius)
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando está enfocado y hay error
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese su teléfono' : null,
                  ),

                  const SizedBox(height: 20),

                  // Input email
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Introduce tu correo electrónico',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.mail,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error (mantiene radius)
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando está enfocado y hay error
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese su email' : null,
                  ),

                  const SizedBox(height: 20),

                  // Input password
                  TextFormField(
                    controller: _passwordController,
                    obscureText:
                        _obscurePassword, // alterna entre ocultar/mostrar
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Ingrese su contraseña',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 110, 110, 110),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error + foco
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) => v == null || v.length < 6
                        ? 'Mínimo 6 caracteres'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  // Input password confirm
                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText:
                        _obscurePasswordConfirm, // alterna entre ocultar/mostrar
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Confirma tu contraseña',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110),
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        size: 20,
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePasswordConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 110, 110, 110),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePasswordConfirm = !_obscurePasswordConfirm;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      // borde normal
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),

                      // borde cuando está enfocado
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blueAccent,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),

                      // borde cuando hay error + foco
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Confirme su contraseña';
                      }
                      if (v.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      if (v != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _onRegisterPressed(context),
                      label: const Text('Registrarse'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulCielo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // const SocialLoginSection(),
                ],
              ),
            )),
      ),
    );
  }
}
