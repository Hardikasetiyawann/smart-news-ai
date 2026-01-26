import 'package:image_picker/image_picker.dart';
import '../entities/publisher.dart';

abstract class PublisherRepository {
  // =========================
  // GET ALL
  // =========================
  Future<List<Publisher>> getAll();

  // =========================
  // CREATE (UPLOAD LOGO)
  // =========================
  Future<void> create({
    required String name,
    String? website,
    XFile? logo, // ⬅️ WAJIB XFile UNTUK WEB
  });

  // =========================
  // UPDATE (UPLOAD LOGO)
  // =========================
  Future<void> update({
    required int id,
    required String name,
    String? website,
    XFile? logo, // ⬅️ WAJIB XFile UNTUK WEB
  });

  // =========================
  // DELETE
  // =========================
  Future<void> delete(int id);
}
