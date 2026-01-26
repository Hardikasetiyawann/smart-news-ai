import 'package:image_picker/image_picker.dart';

abstract class PublisherEvent {}

class LoadPublishers extends PublisherEvent {}

// =========================
// CREATE
// =========================
class CreatePublisherEvent extends PublisherEvent {
  final String name;
  final String? website;
  final XFile? logo; // ⬅️ FIXED

  CreatePublisherEvent({required this.name, this.website, this.logo});
}

// =========================
// UPDATE
// =========================
class UpdatePublisherEvent extends PublisherEvent {
  final int id;
  final String name;
  final String? website;
  final XFile? logo; // ⬅️ FIXED

  UpdatePublisherEvent({
    required this.id,
    required this.name,
    this.website,
    this.logo,
  });
}

// =========================
// DELETE
// =========================
class DeletePublisherEvent extends PublisherEvent {
  final int id;
  DeletePublisherEvent(this.id);
}
