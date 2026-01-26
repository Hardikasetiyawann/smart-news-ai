import 'package:image_picker/image_picker.dart';
import '../repositories/news_repository.dart';

class UpdateNews {
  final NewsRepository repository;

  UpdateNews(this.repository);

  Future<void> call({
    required int id,
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status,
    XFile? image,
  }) async {
    await repository.updateNews(
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
}
