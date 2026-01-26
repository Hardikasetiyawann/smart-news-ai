import '../entities/publisher_news_entity.dart';

abstract class PublisherRepository {
  Future<List<PublisherNewsEntity>> getNewsByPublisherId(
    int publisherId,
  );
}
