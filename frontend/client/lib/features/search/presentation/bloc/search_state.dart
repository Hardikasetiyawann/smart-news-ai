import '../../domain/entities/search_news.dart';

abstract class SearchNewsState {}

class SearchNewsInitial extends SearchNewsState {}

class SearchNewsLoading extends SearchNewsState {}

class SearchNewsLoaded extends SearchNewsState {
  final List<SearchNews> news;

  SearchNewsLoaded(this.news);
}

class SearchNewsEmpty extends SearchNewsState {}

class SearchNewsError extends SearchNewsState {
  final String message;

  SearchNewsError(this.message);
}
