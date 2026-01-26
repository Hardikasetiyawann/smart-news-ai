import 'package:image_picker/image_picker.dart';

import '../../domain/entities/publisher.dart';
import '../../domain/repositories/publisher_repository.dart';
import '../datasources/publisher_remote_datasource.dart';

class PublisherRepositoryImpl implements PublisherRepository {
  final PublisherRemoteDataSource remote;

  PublisherRepositoryImpl(this.remote);

  // =========================
  // GET ALL
  // =========================
  @override
  Future<List<Publisher>> getAll() {
    return remote.getAll();
  }

  // =========================
  // CREATE (UPLOAD LOGO)
  // =========================
  @override
  Future<void> create({
    required String name,
    String? website,
    XFile? logo, // ⬅️ FIXED
  }) {
    return remote.create(name: name, website: website, logo: logo);
  }

  // =========================
  // UPDATE (UPLOAD LOGO)
  // =========================
  @override
  Future<void> update({
    required int id,
    required String name,
    String? website,
    XFile? logo, // ⬅️ FIXED
  }) {
    return remote.update(id: id, name: name, website: website, logo: logo);
  }

  // =========================
  // DELETE
  // =========================
  @override
  Future<void> delete(int id) {
    return remote.delete(id);
  }
}
