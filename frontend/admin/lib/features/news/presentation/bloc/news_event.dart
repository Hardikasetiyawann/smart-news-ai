import 'package:image_picker/image_picker.dart';

abstract class NewsEvent {}

// LOAD
class LoadNewsEvent extends NewsEvent {}

// CREATE
class CreateNewsEvent extends NewsEvent {
  final int categoryId;
  final int publisherId;
  final String title;
  final String content;
  final String linkNews;
  final String status;
  final XFile? image;

  CreateNewsEvent({
    required this.categoryId,
    required this.publisherId,
    required this.title,
    required this.content,
    required this.linkNews,
    required this.status,
    this.image,
  });
}

// UPDATE
class UpdateNewsEvent extends NewsEvent {
  final int id;
  final int categoryId;
  final int publisherId;
  final String title;
  final String content;
  final String linkNews;
  final String status;
  final XFile? image;

  UpdateNewsEvent({
    required this.id,
    required this.categoryId,
    required this.publisherId,
    required this.title,
    required this.content,
    required this.linkNews,
    required this.status,
    this.image,
  });
}

// DELETE
class DeleteNewsEvent extends NewsEvent {
  final int id;

  DeleteNewsEvent(this.id);
}

class GetNewsByIdEvent extends NewsEvent {
  final int id;
  GetNewsByIdEvent(this.id);
}

class SearchNewsEvent extends NewsEvent {
  final String keyword;
  SearchNewsEvent(this.keyword);
}

class SetPublisherMap extends NewsEvent {
  final Map<int, String> publisherMap;
  SetPublisherMap(this.publisherMap);
}
