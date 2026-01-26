import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateEmail extends ProfileEvent {
  final String email;

  const UpdateEmail(this.email);

  @override
  List<Object?> get props => [email];
}


class UpdateProfile extends ProfileEvent {
  final String? fullName;
  final File? avatar;

  const UpdateProfile({this.fullName, this.avatar});

  @override
  List<Object?> get props => [fullName, avatar];
}


class UnlikeNews extends ProfileEvent {
  final int newsId;

  const UnlikeNews(this.newsId);

  @override
  List<Object?> get props => [newsId];
}