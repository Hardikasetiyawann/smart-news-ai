class DetailInteractionEntity {
  final int totalLikes;
  final int totalComments;
  final bool isLiked;
  final bool isBookmarked;

  const DetailInteractionEntity({
    required this.totalLikes,
    required this.totalComments,
    required this.isLiked,
    required this.isBookmarked,
  });

  DetailInteractionEntity copyWith({
    int? totalLikes,
    int? totalComments,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return DetailInteractionEntity(
      totalLikes: totalLikes ?? this.totalLikes,
      totalComments: totalComments ?? this.totalComments,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
