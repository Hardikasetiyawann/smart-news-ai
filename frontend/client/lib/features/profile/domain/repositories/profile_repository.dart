import 'dart:io';

import '../entities/user_entity.dart';
import '../entities/liked_news_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile();

  Future<List<LikedNewsEntity>> getLikedNews();

  Future<void> updateEmail(String email);

  Future<void> updateProfile({String? fullName, File? avatar});

  Future<void> unlikeNews(int newsId);
}