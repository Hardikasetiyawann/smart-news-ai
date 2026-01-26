import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.totalNews,
    required super.totalUsers,
    required super.totalPublishers,
    required super.pendingReports,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalNews: json['total_news'],
      totalUsers: json['total_users'],
      totalPublishers: json['total_publishers'],
      pendingReports: json['pending_reports'],
    );
  }
}
