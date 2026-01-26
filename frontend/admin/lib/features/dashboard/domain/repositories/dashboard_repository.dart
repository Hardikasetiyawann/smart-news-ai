import 'package:admin/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:admin/features/dashboard/domain/entities/recent_news.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getStats();
  Future<List<RecentNews>> getRecentNews();
}
