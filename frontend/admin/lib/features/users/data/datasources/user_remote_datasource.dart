import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final http.Client client;
  UserRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // =====================
  // GET ALL USERS (ADMIN)
  // =====================
  Future<List<UserModel>> getAll() async {
    final res = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.users}'),
      headers: await _headers(),
    );

    final body = jsonDecode(res.body);
    return (body['data'] as List).map((e) => UserModel.fromJson(e)).toList();
  }

  // =====================
  // TOGGLE BLOCK USER
  // =====================
  Future<void> toggleStatus(int userId) async {
    final res = await client.patch(
      Uri.parse('${ApiConstants.baseUrl}/auth-user/$userId/block'),
      headers: await _headers(),
    );

    if (res.statusCode >= 400) {
      throw Exception('Gagal mengubah status user');
    }
  }
}
