import 'package:flutter/material.dart';
import 'success_login_screen.dart';
import 'package:client/auth_service.dart';
import 'app_dialog.dart';

class InputLoginScreen extends StatefulWidget {
  const InputLoginScreen({super.key});

  @override
  State<InputLoginScreen> createState() => _InputLoginScreenState();
}

class _InputLoginScreenState extends State<InputLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;

  bool get isFormFilled =>
      emailController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  Future<void> handleEmailLogin() async {
    if (!isFormFilled) {
      await AppDialog.show(
        context,
        title: 'Form Belum Lengkap',
        message: 'Email dan kata sandi wajib diisi.',
        isError: true,
      );
      return;
    }

    setState(() => loading = true);

    try {
      final user = await AuthService().signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SuccessLoginScreen(),
          ),
        );
      } else {
        await AppDialog.show(
          context,
          title: 'Login Gagal',
          message: 'Email atau kata sandi salah.',
          isError: true,
        );
      }
    } catch (_) {
      await AppDialog.show(
        context,
        title: 'Login Gagal',
        message: 'Terjadi kesalahan saat login. Silakan coba lagi.',
        isError: true,
      );
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // ================= FORM =================
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: isTablet ? 24 : 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 420 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.05),

                        Center(
                          child: Image.asset(
                            "assets/logo/Frame.png",
                            width: isTablet ? 90 : 80,
                          ),
                        ),

                        SizedBox(height: size.height * 0.04),

                        Text(
                          "Login",
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Login ke akun LensNews",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),

                        SizedBox(height: size.height * 0.04),

                        _inputField(
                          controller: emailController,
                          hint: "Masukkan email anda",
                          context: context,
                        ),

                        const SizedBox(height: 16),

                        _passwordField(context),

                        SizedBox(height: size.height * 0.04),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                loading ? null : handleEmailLogin,
                            child: loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Masuk Sekarang",
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ================= FOOTER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kamu belum punya akun?",
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Daftar Sekarang",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required BuildContext context,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: passwordController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        hintText: "Masukkan kata sandi anda",
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => obscurePassword = !obscurePassword),
        ),
      ),
    );
  }
}
