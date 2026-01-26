import 'dart:io';
import 'package:dio/dio.dart';

import '../models/user_model.dart';
import '../models/liked_news_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<List<LikedNewsModel>> getLikedNews();
  Future<void> updateEmail(String email);
  Future<void> updateProfile({String? fullName, File? avatar});
  Future<void> unlikeNews(int newsId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getProfile() async {
    final res = await dio.get('/auth-user/me');
    return UserModel.fromJson(res.data['data']);
  }

  @override
  Future<List<LikedNewsModel>> getLikedNews() async {
    final res = await dio.get('/likes');
    final List data = res.data['data'];
    return data.map((e) => LikedNewsModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateEmail(String email) async {
    await dio.put('/auth-user/email', data: {'email': email});
  }

  @override
  Future<void> updateProfile({String? fullName, File? avatar}) async {
    final formData = FormData.fromMap({});

    if (fullName != null && fullName.isNotEmpty) {
      formData.fields.add(MapEntry('full_name', fullName));
    }

    if (avatar != null) {
      formData.files.add(
        MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
        ),
      );
    }

    await dio.patch(
      '/auth-user/profile',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> unlikeNews(int newsId) async {
    await dio.delete('/likes/$newsId');
  }
}