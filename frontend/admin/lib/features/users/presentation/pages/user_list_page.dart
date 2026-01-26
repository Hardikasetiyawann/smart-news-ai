import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/layout/admin_layout.dart';
import '../../domain/entities/user.dart';
import '../bloc/users_bloc.dart';
import '../bloc/users_event.dart';
import '../bloc/users_state.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const LoadUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AdminLayout(
      showSearch: true,
      onSearch: (keyword) {
        context.read<UserBloc>().add(SearchUserEvent(keyword));
      },
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('Tidak ada user'));
            }

            return isMobile
                ? _MobileUserList(users: state.users)
                : _DesktopUserTable(users: state.users);
          }

          return const SizedBox();
        },
      ),
    );
  }
}

/* ============================================================
   DESKTOP TABLE
============================================================ */
class _DesktopUserTable extends StatelessWidget {
  final List<User> users;
  const _DesktopUserTable({required this.users});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Provider')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: users.map((u) {
          return DataRow(
            cells: [
              // 1️⃣ ID
              DataCell(Text(u.id.toString())),

              // 2️⃣ Nama
              DataCell(Text(u.fullName ?? '-')),

              // 3️⃣ Email
              DataCell(Text(u.email ?? '-')),

              // 4️⃣ Provider
              DataCell(Text(u.authProvider ?? '-')),

              // 5️⃣ Status
              DataCell(
                Chip(
                  label: Text(
                    u.isActive ? 'Aktif' : 'Diblokir',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: u.isActive ? Colors.green : Colors.red,
                ),
              ),

              // 6️⃣ Aksi (WAJIB ADA)
              DataCell(
                Switch(
                  value: u.isActive,
                  onChanged: (value) {
                    context.read<UserBloc>().add(ToggleUserStatusEvent(u.id));
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/* ============================================================
   MOBILE LIST
============================================================ */
class _MobileUserList extends StatelessWidget {
  final List<User> users;
  const _MobileUserList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, i) {
        final u = users[i];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              u.fullName ?? '-',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(u.email ?? '-'),
                const SizedBox(height: 4),
                Text('Provider: ${u.authProvider ?? '-'}'),
                const SizedBox(height: 4),
                Text(
                  u.isActive ? 'Status: Aktif' : 'Status: Diblokir',
                  style: TextStyle(
                    color: u.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Switch(
              value: u.isActive,
              onChanged: (_) {
                // 🔥 SATU EVENT SAJA (TOGGLE)
                context.read<UserBloc>().add(ToggleUserStatusEvent(u.id));
              },
            ),
          ),
        );
      },
    );
  }
}
