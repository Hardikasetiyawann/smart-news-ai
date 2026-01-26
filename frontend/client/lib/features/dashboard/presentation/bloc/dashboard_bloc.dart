import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth_service.dart';
import '../../domain/usecases/get_trending_news.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_publishers.dart';
import '../../domain/usecases/get_news_by_category.dart';
import '../../domain/usecases/get_current_user.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetTrendingNews getTrendingNews;
  final GetLatestNews getLatestNews;
  final GetCategories getCategories;
  final GetPublishers getPublishers;
  final GetNewsByCategory getNewsByCategory;
  final GetCurrentUser getCurrentUser;

  DashboardBloc({
    required this.getTrendingNews,
    required this.getLatestNews,
    required this.getCategories,
    required this.getPublishers,
    required this.getNewsByCategory,
    required this.getCurrentUser,
  }) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<LoadNewsByCategory>(_onLoadNewsByCategory);
  }

  // load dashboard lengkap
  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final token = await AuthService().getJwt();
      if (token == null) {
        throw Exception('Token not found');
      }

      final user = await getCurrentUser.execute();
      final trending = await getTrendingNews();
      final latest = await getLatestNews();
      final categories = await getCategories();
      final publishers = await getPublishers();

      emit(
        DashboardLoaded(
          user: user,
          trendingNews: trending,
          latestNews: latest,
          categories: categories,
          publishers: publishers,
          selectedCategoryId: 0,
        ),
      );
    } catch (e, s) {
      debugPrint('❌ DASHBOARD ERROR: $e');
      debugPrintStack(stackTrace: s);
      emit(DashboardError('Gagal memuat dashboard'));
    }
  }

  // load berita berdasarkan kategori
  Future<void> _onLoadNewsByCategory(
    LoadNewsByCategory event,
    Emitter<DashboardState> emit,
  ) async {
    final current = state;
    if (current is! DashboardLoaded) return;

    try {
      final latestNews = event.categoryId == 0
          ? await getLatestNews()
          : await getNewsByCategory(event.categoryId);

      emit(
        current.copyWith(
          latestNews: latestNews,
          selectedCategoryId: event.categoryId,
        ),
      );
    } catch (e, s) {
      debugPrint('❌ CATEGORY ERROR: $e');
      debugPrintStack(stackTrace: s);
      emit(DashboardError('Gagal memuat berita berdasarkan kategori'));
    }
  }
}
