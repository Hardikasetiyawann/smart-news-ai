import '../../domain/entities/news.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> news;

  NewsLoaded(this.news);
}

class NewsSuccess extends NewsState {
  final String message;

  NewsSuccess(this.message);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}

class NewsDetailLoaded extends NewsState {
  final News news;
  NewsDetailLoaded(this.news);
}
