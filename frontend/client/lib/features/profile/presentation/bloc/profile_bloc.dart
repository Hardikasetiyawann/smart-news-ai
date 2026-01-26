import 'package:client/features/profile/domain/entities/liked_news_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_event.dart';
import 'profile_state.dart';

import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_liked_news_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/unlike_news_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;
  final GetLikedNewsUseCase getLikedNews;
  final UpdateProfileUseCase updateProfile;
  final UnlikeNewsUseCase unlikeNews;

  ProfileBloc({
    required this.getProfile,
    required this.getLikedNews,
    required this.updateProfile,
    required this.unlikeNews,
  }) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);

    on<UpdateProfile>(_onUpdateProfile);
    on<UnlikeNews>(_onUnlikeNews);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await getProfile();

      List<LikedNewsEntity> likedNews = [];
      try {
        likedNews = await getLikedNews();
      } catch (e) {
        debugPrint('⚠️ liked news gagal dimuat: $e');
      }

      emit(ProfileLoaded(user: user, likedNews: likedNews));
    } catch (_) {
      emit(const ProfileError('Gagal memuat profil pengguna'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await updateProfile(fullName: event.fullName, avatar: event.avatar);

      add(LoadProfile());
    } catch (e) {
      emit(const ProfileError('Gagal memperbarui profil'));
    }
  }

  Future<void> _onUnlikeNews(
    UnlikeNews event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await unlikeNews(event.newsId);
      add(LoadProfile());
    } catch (_) {
      emit(const ProfileError('Gagal membatalkan suka'));
    }
  }
}