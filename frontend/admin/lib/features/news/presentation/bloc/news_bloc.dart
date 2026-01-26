import 'package:admin/features/news/domain/usecases/get_news_by_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/news.dart';

import '../../domain/usecases/get_all_news.dart';
import '../../domain/usecases/create_news.dart';
import '../../domain/usecases/update_news.dart';
import '../../domain/usecases/delete_news.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetAllNews getAllNews;
  final CreateNews createNews;
  final UpdateNews updateNews;
  final DeleteNews deleteNews;
  final GetNewsById getNewsById;

  List<News> _allNews = [];
  final Map<int, String> _publisherMap = {};

  NewsBloc({
    required this.getAllNews,
    required this.createNews,
    required this.updateNews,
    required this.deleteNews,
    required this.getNewsById,
  }) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoad);
    on<CreateNewsEvent>(_onCreate);
    on<UpdateNewsEvent>(_onUpdate);
    on<DeleteNewsEvent>(_onDelete);
    on<GetNewsByIdEvent>(_onGetById);
    on<SearchNewsEvent>(_onSearch);
    on<SetPublisherMap>(_onSetPublisherMap);
  }

  void _onSetPublisherMap(SetPublisherMap event, Emitter<NewsState> emit) {}

  Future<void> _onLoad(LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      _allNews = await getAllNews();
      emit(NewsLoaded(_allNews));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  void _onSearch(SearchNewsEvent event, Emitter<NewsState> emit) {
    final keyword = event.keyword.toLowerCase();

    final filtered = _allNews.where((news) {
      final publisherName =
          _publisherMap[news.publisherId]?.toLowerCase() ?? '';

      return news.title.toLowerCase().contains(keyword) ||
          news.content.toLowerCase().contains(keyword) ||
          news.linkNews.toLowerCase().contains(keyword) ||
          news.status.toLowerCase().contains(keyword) ||
          publisherName.contains(keyword);
    }).toList();

    emit(NewsLoaded(filtered));
  }

  Future<void> _onCreate(CreateNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      await createNews(
        categoryId: event.categoryId,
        publisherId: event.publisherId,
        title: event.title,
        content: event.content,
        linkNews: event.linkNews,
        status: event.status,
        image: event.image,
      );
      emit(NewsSuccess("News berhasil dibuat"));
      add(LoadNewsEvent());
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      await updateNews(
        id: event.id,
        categoryId: event.categoryId,
        publisherId: event.publisherId,
        title: event.title,
        content: event.content,
        linkNews: event.linkNews,
        status: event.status,
        image: event.image,
      );
      emit(NewsSuccess("News berhasil diupdate"));
      add(LoadNewsEvent());
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      await deleteNews(event.id);
      emit(NewsSuccess("News berhasil dihapus"));
      add(LoadNewsEvent());
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onGetById(
    GetNewsByIdEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      final news = await getNewsById(event.id);
      emit(NewsDetailLoaded(news));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
