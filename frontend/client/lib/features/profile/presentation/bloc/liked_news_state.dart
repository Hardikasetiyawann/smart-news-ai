import 'package:equatable/equatable.dart';
import '../../domain/entities/liked_news_entity.dart';

abstract class LikedNewsState extends Equatable {
  const LikedNewsState();

  @override
  List<Object?> get props => [];
}

class LikedNewsLoading extends LikedNewsState {}

class LikedNewsLoaded extends LikedNewsState {
  final List<LikedNewsEntity> news;

  const LikedNewsLoaded(this.news);

  @override
  List<Object?> get props => [news];
}

class LikedNewsError extends LikedNewsState {
  final String message;

  const LikedNewsError(this.message);

  @override
  List<Object?> get props => [message];
}