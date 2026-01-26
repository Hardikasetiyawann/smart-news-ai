import '../../domain/entities/detail_interaction_entity.dart';

class DetailInteractionModel extends DetailInteractionEntity {
  const DetailInteractionModel({
    required super.totalLikes,
    required super.totalComments,
    required super.isLiked,
    required super.isBookmarked,
  });

  factory DetailInteractionModel.fromJson(Map<String, dynamic> json) {
    return DetailInteractionModel(
      totalLikes: json['total_like'] ?? 0,
      totalComments: json['total_comment'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isBookmarked: false, 
    );
  }
}
