import 'package:admin/core/utils/date_formatter.dart';
import 'package:admin/core/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';
import '../../domain/entities/admin.dart';
import '../../../../core/layout/admin_layout.dart';

class AdminListPage extends StatefulWidget {
  const AdminListPage({super.key});

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadAdmins());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AdminLayout(
      showSearch: true,
      onSearch: (keyword) {
        context.read<AdminBloc>().add(SearchAdminEvent(keyword));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Admin Management',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin/create');
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Admin'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ================= CONTENT =================
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (_, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AdminLoaded) {
                  if (state.admins.isEmpty) {
                    return const Center(child: Text('Belum ada admin'));
                  }

                  // MOBILE
                  if (width < 768) {
                    return _AdminMobileList(admins: state.admins);
                  }

                  // DESKTOP
                  return _AdminCardTable(admins: state.admins);
                }

                return const Center(child: Text('Gagal memuat data'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MOBILE LIST =================
class _AdminMobileList extends StatelessWidget {
  final List<Admin> admins;
  const _AdminMobileList({required this.admins});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: admins.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final admin = admins[i];

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(admin.email),
                Text(admin.fullName),
                const SizedBox(height: 8),
                Text(
                  admin.lastLogin != null
                      ? 'Last Login: ${formatDateTime(admin.lastLogin!)}'
                      : 'Last Login: -',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ActionIcon(
                      icon: Icons.edit,
                      tooltip: 'Edit',
                      onTap: () async {
                        Navigator.pushNamed(
                          context,
                          '/admin/edit',
                          arguments: admin,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _ActionIcon(
                      icon: Icons.delete,
                      color: Colors.red,
                      tooltip: 'Hapus',
                      onTap: () async {
                        final confirm = await AppDialog.showConfirm(
                          context,
                          title: 'Hapus Admin',
                          message:
                              'Apakah Anda yakin ingin menghapus admin ini?',
                          confirmText: 'Hapus',
                          cancelText: 'Batal',
                        );

                        if (!context.mounted) return;

                        if (confirm) {
                          context.read<AdminBloc>().add(
                            DeleteAdminEvent(admin.id),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ================= DESKTOP TABLE =================
class _AdminCardTable extends StatelessWidget {
  final List<Admin> admins;
  const _AdminCardTable({required this.admins});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _TableHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: admins.length,
              itemBuilder: (_, i) {
                return _TableRow(admin: admins[i]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= TABLE HEADER =================
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.grey.shade100,
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text('ID')),
          Expanded(flex: 2, child: Text('Username')),
          Expanded(flex: 3, child: Text('Email')),
          Expanded(flex: 3, child: Text('Nama')),
          Expanded(flex: 3, child: Text('Last Login')),
          Expanded(flex: 2, child: Text('Aksi')),
        ],
      ),
    );
  }
}

// ================= TABLE ROW =================
class _TableRow extends StatelessWidget {
  final Admin admin;
  const _TableRow({required this.admin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(admin.id.toString())),
          Expanded(flex: 2, child: Text(admin.username)),
          Expanded(flex: 3, child: Text(admin.email)),
          Expanded(flex: 3, child: Text(admin.fullName)),
          Expanded(
            flex: 3,
            child: Text(
              admin.lastLogin != null ? formatDateTime(admin.lastLogin!) : '-',
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _ActionIcon(
                  icon: Icons.edit,
                  tooltip: 'Edit',
                  onTap: () async {
                    Navigator.pushNamed(
                      context,
                      '/admin/edit',
                      arguments: admin,
                    );
                  },
                ),
                const SizedBox(width: 8),
                _ActionIcon(
                  icon: Icons.delete,
                  color: Colors.red,
                  tooltip: 'Hapus',
                  onTap: () async {
                    final confirm = await AppDialog.showConfirm(
                      context,
                      title: 'Hapus Admin',
                      message: 'Apakah Anda yakin ingin menghapus admin ini?',
                      confirmText: 'Hapus',
                      cancelText: 'Batal',
                    );

                    if (!context.mounted) return;

                    if (confirm) {
                      context.read<AdminBloc>().add(DeleteAdminEvent(admin.id));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= ACTION ICON (FIXED) =================
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Future<void> Function() onTap; // ✅ ASYNC SUPPORT
  final String tooltip;
  final Color? color;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: () async => await onTap(),
        radius: 22,
        child: Icon(icon, size: 20, color: color ?? Colors.grey.shade800),
      ),
    );
  }
}
