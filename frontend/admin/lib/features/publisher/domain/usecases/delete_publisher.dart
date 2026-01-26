import '../repositories/publisher_repository.dart';

class DeletePublisher {
  final PublisherRepository repository;
  DeletePublisher(this.repository);

  Future<void> execute(int id) {
    return repository.delete(id);
  }
}
