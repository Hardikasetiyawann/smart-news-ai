import 'package:image_picker/image_picker.dart';

import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<News>> getAllNews() async {
    return await remoteDataSource.getAll();
  }

  @override
  Future<void> createNews({
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status,
    XFile? image,
  }) async {
    await remoteDataSource.create(
      categoryId: categoryId,
      publisherId: publisherId,
      title: title,
      content: content,
      linkNews: linkNews,
      status: status,
      image: image,
    );
  }

  @override
  Future<void> updateNews({
    required int id,
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status,
    XFile? image,
  }) async {
    await remoteDataSource.update(
      id: id,
      categoryId: categoryId,
      publisherId: publisherId,
      title: title,
      content: content,
      linkNews: linkNews,
      status: status,
      image: image,
    );
  }

  @override
  Future<void> deleteNews(int id) async {
    await remoteDataSource.delete(id);
  }

  @override
  Future<News> getById(int id) {
    return remoteDataSource.getById(id);
  }
}
