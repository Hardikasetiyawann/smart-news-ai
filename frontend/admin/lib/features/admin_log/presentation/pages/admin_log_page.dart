import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/core/layout/admin_layout.dart';

import '../bloc/admin_log_bloc.dart';
import '../bloc/admin_log_event.dart';
import '../bloc/admin_log_state.dart';

class AdminLogPage extends StatefulWidget {
  const AdminLogPage({super.key});

  @override
  State<AdminLogPage> createState() => _AdminLogPageState();
}

class _AdminLogPageState extends State<AdminLogPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminLogBloc>().add(LoadAdminLogs());
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return AdminLayout(
      child: BlocBuilder<AdminLogBloc, AdminLogState>(
        builder: (context, state) {
          if (state is AdminLogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminLogLoaded) {
            return isMobile
                ? _MobileLogList(logs: state.logs)
                : _DesktopLogTable(logs: state.logs);
          }

          if (state is AdminLogError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

//
// ================= MOBILE VIEW =================
//
class _MobileLogList extends StatelessWidget {
  final List logs;
  const _MobileLogList({required this.logs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, i) {
        final log = logs[i];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ACTION
                Row(
                  children: [
                    const Icon(Icons.history, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        log.action,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // DETAILS
                Text(log.details, style: const TextStyle(fontSize: 13)),

                const SizedBox(height: 8),

                // ADMIN
                Text(
                  'Oleh: ${log.adminName}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 4),

                // DATE
                Text(
                  _formatDate(log.createdAt),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//
// ================= DESKTOP VIEW =================
//
class _DesktopLogTable extends StatelessWidget {
  final List logs;
  const _DesktopLogTable({required this.logs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text('Aksi')),
          DataColumn(label: Text('Detail')),
          DataColumn(label: Text('Admin')),
          DataColumn(label: Text('Waktu')),
        ],
        rows: logs.map((log) {
          return DataRow(
            cells: [
              DataCell(Text(log.action)),
              DataCell(
                SizedBox(
                  width: 300,
                  child: Text(
                    log.details,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(Text(log.adminName)),
              DataCell(Text(_formatDate(log.createdAt))),
            ],
          );
        }).toList(),
      ),
    );
  }
}

//
// ================= DATE FORMAT =================
//
String _formatDate(DateTime date) {
  final d = date.toLocal();
  return '${d.day.toString().padLeft(2, '0')} '
      '${_month(d.month)} '
      '${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}

String _month(int m) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return months[m - 1];
}
