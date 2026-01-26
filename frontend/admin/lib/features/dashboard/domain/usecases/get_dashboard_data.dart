import '../entities/dashboard_stats.dart';
import '../entities/recent_news.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardData {
  final DashboardRepository repository;

  GetDashboardData(this.repository);

  Future<(DashboardStats, List<RecentNews>)> call() async {
    final stats = await repository.getStats();
    final news = await repository.getRecentNews();
    return (stats, news);
  }
}
