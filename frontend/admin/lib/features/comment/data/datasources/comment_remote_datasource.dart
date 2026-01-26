import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/comment_model.dart';

class CommentRemoteDataSource {
  final http.Client client;
  CommentRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  Future<List<CommentModel>> getByNews(int newsId) async {
    final res = await client.get(
      Uri.parse("${ApiConstants.baseUrl}/comments/news/$newsId"),
      headers: await _headers(),
    );

    final body = jsonDecode(res.body);

    // 🔥 FIX UTAMA
    final List list = body is List ? body : body['data'];

    return list.map((e) => CommentModel.fromJson(e)).toList();
  }

  Future<CommentModel> getById(int id) async {
    final res = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/comments/detail/$id'),
      headers: await _headers(),
    );

    final body = jsonDecode(res.body);
    return CommentModel.fromJson(body['data']);
  }

  Future<void> delete(int id) async {
    await client.delete(
      Uri.parse("${ApiConstants.baseUrl}/comments/$id"),
      headers: await _headers(),
    );
  }
}
