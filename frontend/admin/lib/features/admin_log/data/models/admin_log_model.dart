import '../../domain/entities/admin_log.dart';

class AdminLogModel extends AdminLog {
  AdminLogModel({
    required super.action,
    required super.details,
    required super.adminName,
    required super.createdAt,
  });

  factory AdminLogModel.fromJson(Map<String, dynamic> json) {
    final admin = json['admin'] ?? {};

    return AdminLogModel(
      action: json['action'] ?? '-',
      details: json['details'] ?? '-',
      adminName: admin['full_name'] ?? '-',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
