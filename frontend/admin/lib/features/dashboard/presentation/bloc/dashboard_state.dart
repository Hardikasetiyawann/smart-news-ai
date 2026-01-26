import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/recent_news.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStats stats;
  final List<RecentNews> news;

  DashboardLoaded(this.stats, this.news);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
