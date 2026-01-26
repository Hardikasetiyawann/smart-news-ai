import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/admin_model.dart';

class AdminRemoteDataSource {
  final http.Client client;
  AdminRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<AdminModel>> getAll() async {
    final res = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/admin'),
      headers: await _headers(),
    );

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return (body['data'] as List).map((e) => AdminModel.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat admin');
  }

  Future<void> create({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    final res = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/admin'),
      headers: await _headers(),
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal menambah admin');
    }
  }

  Future<void> update({
    required int id,
    required String username,
    required String email,
    required String fullName,
    String? password, // 👈 opsional
  }) async {
    final Map<String, dynamic> body = {
      'username': username,
      'email': email,
      'full_name': fullName,
    };

    // 🔐 Kirim password hanya jika diisi
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final res = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/admin/$id'),
      headers: await _headers(),
      body: json.encode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal update admin');
    }
  }

  Future<void> delete(int id) async {
    final res = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}/admin/$id'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal hapus admin');
    }
  }
}
