import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'success_login_screen.dart';
import 'input_login_screen.dart';
import 'package:client/auth_service.dart';
import 'app_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 420 : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 28,
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.06),

                    // ================= LOGO =================
                    Image.asset(
                      "assets/logo/Frame.png",
                      width: isTablet ? 140 : 120,
                    ),

                    const SizedBox(height: 20),

                    // ================= TITLE =================
                    Text(
                      "Lens News",
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ================= SUBTITLE =================
                    Text(
                      "Selamat datang! Mari kita lihat akunmu!",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    // ================= GOOGLE LOGIN =================
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: colorScheme.outline.withOpacity(0.4),
                        ),
                      ),
                      onPressed: () async {
                        // loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        try {
                          final user = await AuthService().signInWithGoogle();

                          if (context.mounted) {
                            Navigator.pop(context); // tutup loading
                          }

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
                              title: 'Login Dibatalkan',
                              message:
                                  'Proses login Google dibatalkan oleh pengguna.',
                              isError: true, // ⬅️ WAJIB
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          await AppDialog.show(
                            context,
                            title: 'Login Gagal',
                            message: 'Google Login gagal. Silakan coba lagi.',
                            isError: true, // ⬅️ WAJIB
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/logo/Google.png",
                              width: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Continue with Google",
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),


                    const SizedBox(height: 24),

                    // ================= DIVIDER =================
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Text(
                            "Atau",
                            style: textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ================= PASSWORD LOGIN =================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const InputLoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Sign in with password"),
                      ),
                    ),

                    SizedBox(height: size.height * 0.08),

                    // ================= REGISTER =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Kamu belum punya akun? ",
                          style: textTheme.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Daftar Sekarang",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
