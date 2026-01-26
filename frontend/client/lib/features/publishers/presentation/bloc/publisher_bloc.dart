import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_news_by_publisher.dart';
import 'publisher_event.dart';
import 'publisher_state.dart';

class PublisherBloc extends Bloc<PublisherEvent, PublisherState> {
  final GetNewsByPublisher getNewsByPublisher;

  PublisherBloc({required this.getNewsByPublisher})
    : super(PublisherInitial()) {
    on<LoadPublisherNews>(_onLoadPublisherNews);
  }

  Future<void> _onLoadPublisherNews(
    LoadPublisherNews event,
    Emitter<PublisherState> emit,
  ) async {
    emit(PublisherLoading());

    try {
      final news = await getNewsByPublisher(event.publisherId);
      emit(PublisherLoaded(news));
    } catch (e) {
      emit(const PublisherError('Gagal memuat berita dari publisher'));
    }
  }
}
