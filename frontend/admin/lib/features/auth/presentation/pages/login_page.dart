import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/app_dialog.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/storage/auth_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 900;

          return Row(
            children: [
              if (isDesktop)
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Image.asset(
                      'assets/Logo.png',
                      width: constraints.maxWidth * 0.3,
                    ),
                  ),
                ),

              if (isDesktop) Container(width: 1, color: Colors.grey.shade300),

              Expanded(
                flex: 1,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _buildLoginForm(context),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =======================
  // LOGIN FORM
  // =======================
  Widget _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Welcome",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),

          TextFormField(
            controller: _usernameController,
            decoration: _inputDecoration("Masukkan Username"),
            validator: (value) =>
                value == null || value.isEmpty ? "Wajib diisi" : null,
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: _inputDecoration("Masukkan Password"),
            validator: (value) =>
                value == null || value.isEmpty ? "Wajib diisi" : null,
          ),
          const SizedBox(height: 30),

          SizedBox(
            height: 50,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthSuccess) {
                  await AuthStorage.saveToken(state.admin.token);
                  await AuthStorage.saveAdminName(state.admin.fullName);

                  if (!mounted) return;

                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else if (state is AuthFailure) {
                  AppDialog.showError(context, message: state.message);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return ElevatedButton(
                    onPressed: null,
                    style: _buttonStyle(),
                    child: const CircularProgressIndicator(color: Colors.white),
                  );
                }

                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        LoginPressed(
                          username: _usernameController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                  style: _buttonStyle(),
                  child: Text(
                    "Masuk Sekarang",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =======================
  // STYLES
  // =======================
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2E5C48)),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2E5C48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
    );
  }
}
