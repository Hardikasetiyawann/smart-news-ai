import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../../domain/entities/admin.dart';
import '../../../../core/layout/admin_layout.dart';

class AdminEditPage extends StatelessWidget {
  const AdminEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = ModalRoute.of(context)!.settings.arguments as Admin;

    final usernameCtrl = TextEditingController(text: admin.username);
    final emailCtrl = TextEditingController(text: admin.email);
    final nameCtrl = TextEditingController(text: admin.fullName);
    final passwordCtrl = TextEditingController();

    return AdminLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Admin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: usernameCtrl,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Nama Lengkap'),
          ),
          TextField(
            controller: passwordCtrl,
            decoration: const InputDecoration(
              labelText: 'Password (kosongkan jika tidak diubah)',
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              context.read<AdminBloc>().add(
                UpdateAdminEvent(
                  id: admin.id,
                  username: usernameCtrl.text,
                  email: emailCtrl.text,
                  fullName: nameCtrl.text,
                  password: passwordCtrl.text.isNotEmpty
                      ? passwordCtrl.text
                      : null,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
