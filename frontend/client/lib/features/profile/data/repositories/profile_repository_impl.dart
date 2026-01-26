import 'dart:io';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/liked_news_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<UserEntity> getProfile() {
    return remote.getProfile();
  }

  @override
  Future<List<LikedNewsEntity>> getLikedNews() {
    return remote.getLikedNews();
  }

  @override
  Future<void> updateEmail(String email) {
    return remote.updateEmail(email);
  }

  @override
  Future<void> updateProfile({String? fullName, File? avatar}) {
    return remote.updateProfile(fullName: fullName, avatar: avatar);
  }

  @override
  Future<void> unlikeNews(int newsId) {
    return remote.unlikeNews(newsId);
  }
}