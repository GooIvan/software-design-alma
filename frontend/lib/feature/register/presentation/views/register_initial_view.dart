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

  // Controladores
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  bool _acceptTerms = false;

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
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.registerAcceptTermsError),
        ),
      );
      return;
    }

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
                // ---------------- TÍTULO ----------------
                Text(
                  context.l10n.registerTitle,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.registerMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
                const SizedBox(height: 30),

                // ---------------- INPUTS ----------------
                _buildTextField(
                  controller: _nameController,
                  icon: Icons.person,
                  hint: context.l10n.registerInputName,
                  validator: (v) =>
                      v!.isEmpty ? context.l10n.validationName : null,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  controller: _lastNameController,
                  icon: Icons.person,
                  hint: context.l10n.registerInputLastName,
                  validator: (v) =>
                      v!.isEmpty ? context.l10n.validationLastName : null,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  controller: _cityController,
                  icon: Icons.location_city,
                  hint: context.l10n.registerInputCity,
                  validator: (v) =>
                      v!.isEmpty ? context.l10n.validationCity : null,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  controller: _addressController,
                  icon: Icons.home,
                  hint: context.l10n.registerInputAddress,
                  validator: (v) =>
                      v!.isEmpty ? context.l10n.validationAddress : null,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  controller: _phoneController,
                  icon: Icons.phone,
                  hint: context.l10n.registerInputPhone,
                  validator: (v) =>
                      v!.isEmpty ? context.l10n.validationPhone : null,
                ),

                const SizedBox(height: 20),

                _buildTextField(
                  controller: _emailController,
                  icon: Icons.mail,
                  hint: context.l10n.registerInputEmail,
                  validator: (v) =>
                      v!.isEmpty ? context.l10n.validationEmail : null,
                ),

                const SizedBox(height: 20),

                _buildPasswordField(
                  controller: _passwordController,
                  obscure: _obscurePassword,
                  toggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  hint: context.l10n.registerInputPassword,
                  validator: (v) =>
                      v!.length < 6 ? context.l10n.validationPassword : null,
                ),

                const SizedBox(height: 20),

                _buildPasswordField(
                  controller: _passwordConfirmController,
                  obscure: _obscurePasswordConfirm,
                  toggle: () => setState(
                      () => _obscurePasswordConfirm = !_obscurePasswordConfirm),
                  hint: context.l10n.registerInputConfirmPassword,
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

                const SizedBox(height: 25),

                // ---------------- CHECKBOX TÉRMINOS ----------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/terms");
                        },
                        child: Text(
                          context.l10n.registerAcceptTerms,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ---------------- BOTÓN REGISTRO ----------------
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
                    icon: const Icon(Icons.check),
                  ),
                ),

                const SizedBox(height: 20),

                const SocialRegisterSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ************************************************************
  // -------------------- WIDGETS REUTILIZABLES -----------------
  // ************************************************************

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
            Icon(icon, size: 20, color: const Color.fromARGB(255, 110, 110, 110)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: _borderNone(),
        focusedBorder: _borderBlue(),
        errorBorder: _borderRed(),
        focusedErrorBorder: _borderRed(),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscure,
    required Function toggle,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
            const Icon(Icons.vpn_key, size: 20, color: Color.fromARGB(255, 110, 110, 110)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(255, 110, 110, 110),
          ),
          onPressed: () => toggle(),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: _borderNone(),
        focusedBorder: _borderBlue(),
        errorBorder: _borderRed(),
        focusedErrorBorder: _borderRed(),
      ),
      validator: validator,
    );
  }

  OutlineInputBorder _borderNone() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }

  OutlineInputBorder _borderBlue() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
    );
  }

  OutlineInputBorder _borderRed() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    );
  }
}
