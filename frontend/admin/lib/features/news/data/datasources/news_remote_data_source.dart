import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/news_model.dart';

class NewsRemoteDataSource {
  final http.Client client;
  NewsRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  // =========================
  // GET ALL NEWS (ADMIN)
  // =========================
  Future<List<NewsModel>> getAll() async {
    final response = await client.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.news),
      headers: await _headers(),
    );

    if (response.statusCode >= 400) {
      throw Exception('Gagal mengambil data news');
    }

    final body = jsonDecode(response.body) as List;
    return body.map((e) => NewsModel.fromJson(e)).toList();
  }

  // =========================
  // CREATE NEWS (WEB SAFE)
  // =========================
  Future<void> create({
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status, // draft | published
    XFile? image,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.baseUrl + ApiConstants.news),
    );

    request.headers.addAll(await _headers());

    request.fields.addAll({
      'category_id': categoryId.toString(),
      'publisher_id': publisherId.toString(),
      'title': title,
      'content': content,
      'link_news': linkNews,
      'status': status,
    });

    // 🔥 WAJIB "image" (sesuai multer.single("image"))
    if (image != null) {
      final bytes = await image.readAsBytes();

      if (bytes.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes('image', bytes, filename: image.name),
        );
      }
    }
    final response = await request.send();
    if (response.statusCode >= 400) {
      throw Exception('Gagal create news');
    }
  }

  // =========================
  // UPDATE NEWS (WEB SAFE)
  // =========================
  Future<void> update({
    required int id,
    required int categoryId,
    required int publisherId,
    required String title,
    required String content,
    required String linkNews,
    required String status,
    XFile? image,
  }) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.news}/$id"),
    );

    request.headers.addAll(await _headers());

    request.fields.addAll({
      'category_id': categoryId.toString(),
      'publisher_id': publisherId.toString(),
      'title': title,
      'content': content,
      'link_news': linkNews,
      'status': status,
    });

    if (image != null) {
      final bytes = await image.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('image', bytes, filename: image.name),
      );
    }

    final response = await request.send();
    if (response.statusCode >= 400) {
      throw Exception('Gagal update news');
    }
  }

  // =========================
  // DELETE NEWS
  // =========================
  Future<void> delete(int id) async {
    final response = await client.delete(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.news}/$id"),
      headers: await _headers(),
    );

    if (response.statusCode >= 400) {
      throw Exception('Gagal hapus news');
    }
  }

  Future<NewsModel> getById(int id) async {
    final response = await client.get(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.news}/$id"),
      headers: await _headers(),
    );

    final body = jsonDecode(response.body);
    return NewsModel.fromJson(body['data']);
  }
}
