import 'package:dio/dio.dart';

import '../models/dashboard_user_model.dart';
import '../models/dashboard_news_model.dart';
import '../models/dashboard_category_model.dart';
import '../models/dashboard_publisher_model.dart';

class DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSource(this._dio);

// metode bantu untuk mengekstrak list dari response API
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) {
      return data['data'];
    }
    return [];
  }

// get current user
  Future<DashboardUserModel> getCurrentUser() async {
    final res = await _dio.get('/auth-user/me');
    return DashboardUserModel.fromJson(res.data['data']);
  }

// get latest news
  Future<List<DashboardNewsModel>> getLatestNews() async {
    final res = await _dio.get('/news/latest');
    return _extractList(res.data)
        .map((e) => DashboardNewsModel.fromJson(e))
        .toList();
  }
// get trending news
  Future<List<DashboardNewsModel>> getTrendingNews() async {
    final res = await _dio.get('/news/trending');
    return _extractList(res.data)
        .map((e) => DashboardNewsModel.fromJson(e))
        .toList();
  }
// get news by category
  Future<List<DashboardNewsModel>> getNewsByCategory(int categoryId) async {
    final res = await _dio.get('/news/kategori/$categoryId');
    return _extractList(res.data)
        .map((e) => DashboardNewsModel.fromJson(e))
        .toList();
  }
// get news by publisher
  Future<List<DashboardNewsModel>> getNewsByPublisher(int publisherId) async {
    final res = await _dio.get('/news/publisher/$publisherId');
    return _extractList(res.data)
        .map((e) => DashboardNewsModel.fromJson(e))
        .toList();
  }
// get categories
  Future<List<DashboardCategoryModel>> getCategories() async {
    final res = await _dio.get('/categories');
    return _extractList(res.data)
        .map((e) => DashboardCategoryModel.fromJson(e))
        .toList();
  }
// get publishers
  Future<List<DashboardPublisherModel>> getPublishers() async {
    final res = await _dio.get('/publishers');
    return _extractList(res.data)
        .map((e) => DashboardPublisherModel.fromJson(e))
        .toList();
  }
}
