import 'package:image_picker/image_picker.dart';

import '../repositories/publisher_repository.dart';

class CreatePublisher {
  final PublisherRepository repository;

  CreatePublisher(this.repository);

  Future<void> execute({
    required String name,
    String? website,
    XFile? logo, // ⬅️ FIX: nullable
  }) {
    return repository.create(name: name, website: website, logo: logo);
  }
}
