import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_detail_news.dart';
import '../../domain/usecases/get_detail_ai_summary.dart';
import '../../domain/usecases/get_detail_interaction.dart';
import '../../domain/usecases/record_news_view.dart';

import '../../../bookmark/domain/usecases/add_bookmark.dart';
import '../../../bookmark/domain/usecases/remove_bookmark.dart';
import '../../../bookmark/domain/usecases/is_bookmarked.dart';
import '../../../bookmark/domain/entities/bookmark_entity.dart';

import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetDetailNews getDetailNews;
  final GetDetailAiSummary getDetailAiSummary;
  final GetDetailInteraction getDetailInteraction;
  final RecordNewsView recordNewsView;
  final AddBookmark addBookmark;
  final RemoveBookmark removeBookmark;
  final IsBookmarked isBookmarked;

  DetailBloc({
    required this.getDetailNews,
    required this.getDetailAiSummary,
    required this.getDetailInteraction,
    required this.recordNewsView,
    required this.addBookmark,
    required this.removeBookmark,
    required this.isBookmarked,
  }) : super(DetailInitial()) {
    on<DetailLoadRequested>(_onLoadRequested);
    on<DetailToggleAiSummary>(_onToggleAiSummary);
    on<DetailToggleLike>(_onToggleLike);
    on<DetailReloadInteraction>(_onReloadInteraction);
    on<DetailToggleBookmark>(_onToggleBookmark);
  }
  // load detail news
  Future<void> _onLoadRequested(
    DetailLoadRequested event,
    Emitter<DetailState> emit,
  ) async {
    emit(DetailLoading());

    try {
      await recordNewsView.execute(event.newsId);
      final news = await getDetailNews.execute(event.newsId);
      final interaction = await getDetailInteraction.execute(event.newsId);
      final bookmarked = await isBookmarked(event.newsId.toString());

      emit(
        DetailLoaded(
          news: news,
          interaction: interaction.copyWith(isBookmarked: bookmarked),
          displayedContent: news.content,
        ),
      );
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }

  //toogle bookmark
  Future<void> _onToggleBookmark(
    DetailToggleBookmark event,
    Emitter<DetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DetailLoaded) return;

    final news = currentState.news;
    final isSaved = currentState.interaction.isBookmarked;

    try {
      if (isSaved) {
        await removeBookmark(news.id.toString());
      } else {
        await addBookmark(
          BookmarkEntity(
            id: news.id.toString(),
            title: news.title,
            imageUrl: news.imageUrl,
            category: news.category.name,
            publisher: news.publisher.name,
            publisherLogo: news.publisher.logoUrl ?? '',
            time: news.publishedAt.toIso8601String(),
            content: news.content,
          ),
        );
      }

      emit(
        currentState.copyWith(
          interaction: currentState.interaction.copyWith(
            isBookmarked: !isSaved,
          ),
        ),
      );
    } catch (_) {}
  }

  // toggle like
  Future<void> _onToggleLike(
    DetailToggleLike event,
    Emitter<DetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DetailLoaded) return;

    try {
      if (currentState.interaction.isLiked) {
        await getDetailInteraction.unlike(currentState.news.id);
      } else {
        await getDetailInteraction.like(currentState.news.id);
      }

      //AMBIL DATA DARI SERVER
      final serverInteraction = await getDetailInteraction.execute(
        currentState.news.id,
      );

      //PERTAHANKAN BOOKMARK (LOCAL SOURCE OF TRUTH)
      final mergedInteraction = serverInteraction.copyWith(
        isBookmarked: currentState.interaction.isBookmarked,
      );

      emit(currentState.copyWith(interaction: mergedInteraction));
    } catch (_) {
      // silent fail
    }
  }

  // =====================
  // AI SUMMARY
  // =====================
  Future<void> _onToggleAiSummary(
    DetailToggleAiSummary event,
    Emitter<DetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DetailLoaded) return;

    if (currentState.isAiMode) {
      emit(
        currentState.copyWith(
          isAiMode: false,
          displayedContent: currentState.news.content,
        ),
      );
      return;
    }

    emit(currentState.copyWith(isLoadingAi: true));

    try {
      final summary = await getDetailAiSummary.execute(currentState.news.id);

      emit(
        currentState.copyWith(
          displayedContent: summary,
          isAiMode: true,
          isLoadingAi: false,
        ),
      );
    } catch (_) {
      emit(currentState.copyWith(isLoadingAi: false));
    }
  }

  // =====================
  // RELOAD INTERACTION
  // =====================
  Future<void> _onReloadInteraction(
    DetailReloadInteraction event,
    Emitter<DetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DetailLoaded) return;

    try {
      final updated = await getDetailInteraction.execute(currentState.news.id);
      emit(currentState.copyWith(interaction: updated));
    } catch (_) {}
  }
}
