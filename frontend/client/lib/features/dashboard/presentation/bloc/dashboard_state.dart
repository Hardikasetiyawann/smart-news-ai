import '../../domain/entities/dashboard_news_entity.dart';
import '../../domain/entities/dashboard_category_entity.dart';
import '../../domain/entities/dashboard_publisher_entity.dart';
import '../../domain/entities/dashboard_user_entity.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardUserEntity user;
  final List<DashboardNewsEntity> trendingNews;
  final List<DashboardNewsEntity> latestNews;
  final List<DashboardCategoryEntity> categories;
  final List<DashboardPublisherEntity> publishers;
  final int selectedCategoryId;

  DashboardLoaded({
    required this.user,
    required this.trendingNews,
    required this.latestNews,
    required this.categories,
    required this.publishers,
    required this.selectedCategoryId,
  });

  // helper untuk update sebagian state
  DashboardLoaded copyWith({
    DashboardUserEntity? user,
    List<DashboardNewsEntity>? trendingNews,
    List<DashboardNewsEntity>? latestNews,
    List<DashboardCategoryEntity>? categories,
    List<DashboardPublisherEntity>? publishers,
    int? selectedCategoryId,
  }) {
    return DashboardLoaded(
      user: user ?? this.user,
      trendingNews: trendingNews ?? this.trendingNews,
      latestNews: latestNews ?? this.latestNews,
      categories: categories ?? this.categories,
      publishers: publishers ?? this.publishers,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
