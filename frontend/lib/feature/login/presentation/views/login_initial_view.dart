import 'package:design_alma/utils/extensions.dart';
import 'package:design_alma/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/social_login_section.dart';
import '../../data/bloc/login_bloc.dart';

class LoginInitialView extends StatefulWidget {
  const LoginInitialView({super.key});

  @override
  State<LoginInitialView> createState() => _LoginInitialViewState();
}

class _LoginInitialViewState extends State<LoginInitialView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true; // para controlar el ojito

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
    final azulPrimary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar de login
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: azulPrimary,
                    borderRadius:
                        BorderRadius.circular(30), // ajusta aquí el redondeo
                  ),
                  child: Icon(
                    Icons.lock,
                    size: 50,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Título
                Text(
                  context.l10n.loginTitle,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.loginMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
                const SizedBox(height: 30),

                // Email
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: 15),
                  decoration: InputDecoration(
                    hintText: context.l10n.inputEmail,
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
                    fillColor: Theme.of(context).appBarTheme.backgroundColor ??
                        Colors.white,

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
                  validator: (v) => v == null || v.isEmpty
                      ? context.l10n.validationEmail
                      : null,
                ),

                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText:
                      _obscurePassword, // alterna entre ocultar/mostrar
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: 15),
                  decoration: InputDecoration(
                    hintText: context.l10n.inputPassword,
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
                    fillColor: Theme.of(context).appBarTheme.backgroundColor ??
                        Colors.white,

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
                      ? context.l10n.validationPassword
                      : null,
                ),

                const SizedBox(height: 10),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      CustomAlert.warning(
                        context,
                        context.l10n.functionalityNotImplemented,
                      );
                    },
                    child: Text(
                      context.l10n.forgotPassword,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _onLoginPressed(context),
                    label: Text(context.l10n.signin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulPrimary,
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

                const SocialLoginSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
