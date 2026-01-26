import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/recent_news.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../models/dashboard_stats_model.dart';
import '../models/recent_news_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl({required this.remote});

  @override
  Future<DashboardStats> getStats() async {
    final data = await remote.fetchDashboard();
    return DashboardStatsModel.fromJson(data['stats']);
  }

  @override
  Future<List<RecentNews>> getRecentNews() async {
    final data = await remote.fetchDashboard();
    return (data['recent_news'] as List)
        .map((e) => RecentNewsModel.fromJson(e))
        .toList();
  }
}
