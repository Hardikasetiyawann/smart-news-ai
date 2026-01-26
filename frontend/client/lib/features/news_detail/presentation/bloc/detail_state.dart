import '../../domain/entities/detail_news_entity.dart';
import '../../domain/entities/detail_interaction_entity.dart';

abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final DetailNewsEntity news;
  final DetailInteractionEntity interaction;

  final String displayedContent;
  final bool isAiMode;
  final bool isLoadingAi;
  final String? errorMessage;

  DetailLoaded({
    required this.news,
    required this.interaction,
    required this.displayedContent,
    this.isAiMode = false,
    this.isLoadingAi = false,
    this.errorMessage,
  });

  DetailLoaded copyWith({
    DetailNewsEntity? news,
    DetailInteractionEntity? interaction,
    String? displayedContent,
    bool? isAiMode,
    bool? isLoadingAi,
    String? errorMessage,
  }) {
    return DetailLoaded(
      news: news ?? this.news,
      interaction: interaction ?? this.interaction,
      displayedContent: displayedContent ?? this.displayedContent,
      isAiMode: isAiMode ?? this.isAiMode,
      isLoadingAi: isLoadingAi ?? this.isLoadingAi,
      errorMessage: errorMessage,
    );
  }
}

class DetailError extends DetailState {
  final String message;
  DetailError(this.message);
}
