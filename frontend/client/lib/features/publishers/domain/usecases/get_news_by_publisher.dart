import '../entities/publisher_news_entity.dart';
import '../repositories/publisher_repository.dart';

class GetNewsByPublisher {
  final PublisherRepository repository;

  GetNewsByPublisher(this.repository);

  Future<List<PublisherNewsEntity>> call(int publisherId) {
    return repository.getNewsByPublisherId(publisherId);
  }
}
