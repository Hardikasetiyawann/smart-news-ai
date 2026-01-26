import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:client/auth_service.dart';
import 'app_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  bool loading = false;

  bool get isFormFilled =>
      emailController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty &&
      confirmController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    confirmController.addListener(() => setState(() {}));
  }

  Future<void> handleRegister() async {
    if (!isFormFilled) {
      await AppDialog.show(
        context,
        title: 'Form Belum Lengkap',
        message: 'Silakan lengkapi seluruh data terlebih dahulu.',
      );
      return;
    }

    if (passwordController.text != confirmController.text) {
      await AppDialog.show(
        context,
        title: 'Kata Sandi Tidak Cocok',
        message: 'Password dan konfirmasi password harus sama.',
      );
      return;
    }

    setState(() => loading = true);

    try {
      await AuthService().registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      await AppDialog.show(
        context,
        title: 'Registrasi Berhasil',
        message: 'Akun berhasil dibuat. Silakan login.',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      await AppDialog.show(
        context,
        title: 'Registrasi Gagal',
        message: e.toString(),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    Center(
                      child: Image.asset(
                        "assets/logo/Frame.png",
                        width: 80,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Sign Up",
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Daftar ke akun LensNews",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _input(context, emailController, "Masukkan email"),
                    const SizedBox(height: 16),

                    _password(
                      context,
                      passwordController,
                      "Kata sandi",
                      obscure1,
                      () => setState(() => obscure1 = !obscure1),
                    ),
                    const SizedBox(height: 16),

                    _password(
                      context,
                      confirmController,
                      "Konfirmasi kata sandi",
                      obscure2,
                      () => setState(() => obscure2 = !obscure2),
                    ),

                    const SizedBox(height: 26),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            isFormFilled && !loading ? handleRegister : null,
                        child: loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text("Daftar Sekarang"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: textTheme.bodySmall,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Masuk Sekarang",
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

  Widget _input(
    BuildContext context,
    TextEditingController controller,
    String hint,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: _box(context),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _password(
    BuildContext context,
    TextEditingController controller,
    String hint,
    bool obscure,
    VoidCallback toggle,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: _box(context),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  BoxDecoration _box(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withOpacity(0.12),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
