import 'package:equatable/equatable.dart';

abstract class PublisherEvent extends Equatable {
  const PublisherEvent();

  @override
  List<Object?> get props => [];
}

class LoadPublisherNews extends PublisherEvent {
  final int publisherId;

  const LoadPublisherNews(this.publisherId);

  @override
  List<Object?> get props => [publisherId];
}
