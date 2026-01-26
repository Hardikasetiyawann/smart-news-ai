import '../../domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.category,
    required super.publisher,
    required super.publisherLogo,
    required super.time,
    required super.content,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'],
      title: map['title'],
      imageUrl: map['image_url'],
      category: map['category'],
      publisher: map['publisher'],
      publisherLogo: map['publisher_logo'],
      time: map['time'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'category': category,
      'publisher': publisher,
      'publisher_logo': publisherLogo,
      'time': time,
      'content': content,
    };
  }
}
