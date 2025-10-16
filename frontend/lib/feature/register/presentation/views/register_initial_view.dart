import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/bloc/register_bloc.dart';
import '../widgets/social_register_section.dart';

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
                  Text(
                    context.l10n.registerTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.registerMessage,
                    style: const TextStyle(
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
                      hintText: context.l10n.registerInputName,
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
                    validator: (v) => v == null || v.isEmpty
                        ? context.l10n.validationName
                        : null,
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
                      hintText: context.l10n.registerInputLastName,
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
                    validator: (v) => v == null || v.isEmpty
                        ? context.l10n.validationLastName
                        : null,
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
                      hintText: context.l10n.registerInputCity,
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
                    validator: (v) => v == null || v.isEmpty
                        ? context.l10n.validationCity
                        : null,
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
                      hintText: context.l10n.registerInputAddress,
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
                    validator: (v) => v == null || v.isEmpty
                        ? context.l10n.validationAddress
                        : null,
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
                      hintText: context.l10n.registerInputPhone,
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
                    validator: (v) => v == null || v.isEmpty
                        ? context.l10n.validationPhone
                        : null,
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
                      hintText: context.l10n.registerInputEmail,
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
                    validator: (v) => v == null || v.isEmpty
                        ? context.l10n.validationEmail
                        : null,
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
                      hintText: context.l10n.registerInputPassword,
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
                        ? context.l10n.validationPassword
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
                      hintText: context.l10n.registerInputConfirmPassword,
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
                      if (v == null || v.isEmpty || v.length < 6) {
                        return context.l10n.validationConfirmPassword;
                      }
                      if (v != _passwordController.text) {
                        return context.l10n.validationConfirmPasswordNotMatch;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _onRegisterPressed(context),
                      label: Text(context.l10n.signup),
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

                  const SocialRegisterSection(),
                ],
              ),
            )),
      ),
    );
  }
}
