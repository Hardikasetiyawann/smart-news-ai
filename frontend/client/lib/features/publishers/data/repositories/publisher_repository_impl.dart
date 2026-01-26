import '../../domain/entities/publisher_news_entity.dart';
import '../../domain/repositories/publisher_repository.dart';
import '../datasources/publisher_remote_datasource.dart';

class PublisherRepositoryImpl implements PublisherRepository {
  final PublisherRemoteDataSource remoteDataSource;

  PublisherRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PublisherNewsEntity>> getNewsByPublisherId(
    int publisherId,
  ) async {
    final models =
        await remoteDataSource.getNewsByPublisherId(publisherId);

    // model extends entity → langsung return
    return models;
  }
}
