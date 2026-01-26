import '../repositories/publisher_repository.dart';
import '../entities/publisher.dart';

class GetPublishers {
  final PublisherRepository repository;
  GetPublishers(this.repository);

  Future<List<Publisher>> execute() {
    return repository.getAll();
  }
}
