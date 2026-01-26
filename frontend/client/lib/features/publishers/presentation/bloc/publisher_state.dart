import 'package:equatable/equatable.dart';
import '../../domain/entities/publisher_news_entity.dart';

abstract class PublisherState extends Equatable {
  const PublisherState();

  @override
  List<Object?> get props => [];
}

class PublisherInitial extends PublisherState {}

class PublisherLoading extends PublisherState {}

class PublisherLoaded extends PublisherState {
  final List<PublisherNewsEntity> news;

  const PublisherLoaded(this.news);

  @override
  List<Object?> get props => [news];
}

class PublisherError extends PublisherState {
  final String message;

  const PublisherError(this.message);

  @override
  List<Object?> get props => [message];
}
