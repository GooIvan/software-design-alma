import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../services/auth_service.dart';
import '../../../routes/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(AuthService()),
      child: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(EmailChanged(_emailController.text));
      context.read<LoginBloc>().add(PasswordChanged(_passwordController.text));
      context.read<LoginBloc>().add(LoginSubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.isFailure && state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("¡Has iniciado sesión con éxito!"),
                    backgroundColor: Colors.green,
                  ),
                );

                // ✅ Navegación con ruta nombrada para mantener MainScaffold tras refresh
                Navigator.pushReplacementNamed(context, AppRoute.main);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "👋 Bienvenido",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Ingresa tu correo y contraseña para continuar",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 40),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Correo electrónico",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El correo es obligatorio';
                        }
                        if (!_emailRegex.hasMatch(value.trim())) {
                          return 'Formato de correo inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'La contraseña es obligatoria';
                        }
                        if (value.trim().length < 6) {
                          return 'Debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Olvidaste contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoute.forgotPassword);
                        },
                        child: const Text("¿Olvidaste tu contraseña?"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Botón login
                    state.isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () => _submitLogin(context),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.indigo,
                            ),
                            child: const Text(
                              "Iniciar sesión",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),

                    // Divider + registro
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey.shade400),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("¿No tienes cuenta?"),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Botón registro
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.register);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.indigo),
                      ),
                      child: const Text(
                        "Crear una cuenta",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
