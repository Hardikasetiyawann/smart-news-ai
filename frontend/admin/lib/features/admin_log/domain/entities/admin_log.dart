class AdminLog {
  final String action;
  final String details;
  final String adminName;
  final DateTime createdAt;

  AdminLog({
    required this.action,
    required this.details,
    required this.adminName,
    required this.createdAt,
  });
}
