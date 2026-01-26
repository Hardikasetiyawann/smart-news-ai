import '../../domain/entities/ai_summary.dart';

class AiSummaryModel extends AiSummary {
  AiSummaryModel({
    required super.id,
    required super.summaryText,
    required super.modelName,
    required super.newsTitle,
  });

  factory AiSummaryModel.fromJson(Map<String, dynamic> json) {
    return AiSummaryModel(
      id: json['id'],
      summaryText: json['summary_text'],
      modelName: json['model_name'],
      newsTitle: json['news']['title'],
    );
  }
}
