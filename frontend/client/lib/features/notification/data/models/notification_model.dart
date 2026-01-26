class NotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String type;
  final int? newsId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.type,
    this.newsId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'] ?? false,
      type: json['type'],
      newsId: json['news_id'],
    );
  }
}
