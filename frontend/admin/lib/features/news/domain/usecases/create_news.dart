import 'package:image_picker/image_picker.dart';
import '../repositories/news_repository.dart';

class CreateNews {
  final NewsRepository repository;

  CreateNews(this.repository);

  Future<void> call({
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status,
    XFile? image,
  }) async {
    await repository.createNews(
      categoryId: categoryId,
      publisherId: publisherId,
      title: title,
      content: content,
      linkNews: linkNews,
      status: status,
      image: image,
    );
  }
}
