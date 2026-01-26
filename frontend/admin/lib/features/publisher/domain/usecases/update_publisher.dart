import '../repositories/publisher_repository.dart';

class UpdatePublisher {
  final PublisherRepository repository;
  UpdatePublisher(this.repository);

  Future<void> execute({
    required int id,
    required String name,
    String? website,
    dynamic logo,
  }) {
    return repository.update(id: id, name: name, website: website, logo: logo);
  }
}
