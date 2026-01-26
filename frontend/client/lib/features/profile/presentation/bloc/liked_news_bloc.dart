import 'package:flutter_bloc/flutter_bloc.dart';
import 'liked_news_event.dart';
import 'liked_news_state.dart';
import '../../domain/usecases/get_liked_news_usecase.dart';

class LikedNewsBloc extends Bloc<LikedNewsEvent, LikedNewsState> {
  final GetLikedNewsUseCase getLikedNews;

  LikedNewsBloc(this.getLikedNews) : super(LikedNewsLoading()) {
    on<LoadLikedNews>(_onLoadLikedNews);
  }

  Future<void> _onLoadLikedNews(
    LoadLikedNews event,
    Emitter<LikedNewsState> emit,
  ) async {
    emit(LikedNewsLoading());

    try {
      final news = await getLikedNews();
      emit(LikedNewsLoaded(news));
    } catch (_) {
      emit(const LikedNewsError(
        'Gagal memuat berita yang disukai',
      ));
    }
  }
}