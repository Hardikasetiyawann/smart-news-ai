class NotificationSettingsModel {
  final bool news;
  final bool silent;

  NotificationSettingsModel({
    required this.news,
    required this.silent,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      news: json['news'] ?? true,
      silent: json['silent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'news': news,
        'silent': silent,
      };
}
