import '../../domain/entities/publisher.dart';

abstract class PublisherState {}

class PublisherInitial extends PublisherState {}

class PublisherLoading extends PublisherState {}

class PublisherLoaded extends PublisherState {
  final List<Publisher> publishers;
  PublisherLoaded(this.publishers);
}

class PublisherError extends PublisherState {
  final String message;
  PublisherError(this.message);
}
