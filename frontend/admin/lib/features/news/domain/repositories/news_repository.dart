import 'package:image_picker/image_picker.dart';
import '../entities/news.dart';

abstract class NewsRepository {
  Future<List<News>> getAllNews();
  Future<News> getById(int id);
  Future<void> createNews({
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status,
    XFile? image,
  });

  Future<void> updateNews({
    required int id,
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status,
    XFile? image,
  });

  Future<void> deleteNews(int id);
}
