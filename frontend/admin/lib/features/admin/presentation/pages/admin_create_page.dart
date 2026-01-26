import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../../../../core/layout/admin_layout.dart';

class AdminCreatePage extends StatelessWidget {
  const AdminCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    return AdminLayout(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ================= HEADER =================
                  const Text(
                    'Tambah Admin',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Isi data admin dengan benar',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 24),

                  // ================= FORM =================
                  _InputField(
                    controller: usernameCtrl,
                    label: 'Username',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  _InputField(
                    controller: emailCtrl,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  _InputField(
                    controller: passwordCtrl,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),

                  _InputField(
                    controller: nameCtrl,
                    label: 'Nama Lengkap',
                    icon: Icons.badge,
                  ),

                  const SizedBox(height: 32),

                  // ================= ACTION =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        onPressed: () {
                          context.read<AdminBloc>().add(
                            CreateAdminEvent(
                              username: usernameCtrl.text,
                              email: emailCtrl.text,
                              password: passwordCtrl.text,
                              fullName: nameCtrl.text,
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= INPUT FIELD =================
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
