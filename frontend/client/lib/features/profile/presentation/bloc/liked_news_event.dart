import 'package:equatable/equatable.dart';

abstract class LikedNewsEvent extends Equatable {
  const LikedNewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLikedNews extends LikedNewsEvent {}