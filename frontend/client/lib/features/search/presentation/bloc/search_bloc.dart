import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_news.dart';
import 'search_event.dart';
import 'search_state.dart';


class SearchNewsBloc extends Bloc<SearchNewsEvent, SearchNewsState> {
  final SearchNewsUseCase searchNewsUseCase;

  SearchNewsBloc(this.searchNewsUseCase) : super(SearchNewsInitial()) {
    on<SearchNewsRequested>(_onSearchNewsRequested);
    on<SearchNewsCleared>(_onSearchNewsCleared);
  }

  Future<void> _onSearchNewsRequested(
    SearchNewsRequested event,
    Emitter<SearchNewsState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchNewsInitial());
      return;
    }

    emit(SearchNewsLoading());

    try {
      final result = await searchNewsUseCase.execute(query);

      if (result.isEmpty) {
        emit(SearchNewsEmpty());
      } else {
        emit(SearchNewsLoaded(result));
      }
    } catch (e) {
      emit(SearchNewsError(e.toString()));
    }
  }

  void _onSearchNewsCleared(
    SearchNewsCleared event,
    Emitter<SearchNewsState> emit,
  ) {
    emit(SearchNewsInitial());
  }
}
