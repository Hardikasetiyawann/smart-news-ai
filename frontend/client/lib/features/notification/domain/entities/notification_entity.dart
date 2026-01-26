import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  /// optional business fields
  final String type; // broadcast | interaction
  final int? newsId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.newsId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        createdAt,
        isRead,
        type,
        newsId,
      ];
}
