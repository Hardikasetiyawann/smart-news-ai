abstract class SearchNewsEvent {}

class SearchNewsRequested extends SearchNewsEvent {
  final String query;

  SearchNewsRequested(this.query);
}

class SearchNewsCleared extends SearchNewsEvent {}
