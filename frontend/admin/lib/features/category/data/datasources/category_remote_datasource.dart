import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/category.dart';
import '../../../../core/storage/auth_storage.dart';

class CategoryRemoteDataSource {
  final http.Client client;
  CategoryRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Category>> getAll() async {
    final res = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/categories'),
      headers: await _headers(),
    );

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      return (body['data'] as List).map((e) => Category.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat kategori');
  }

  Future<void> create(String name) async {
    final res = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/categories'),
      headers: await _headers(),
      body: json.encode({'name': name}),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal menambah kategori');
    }
  }

  Future<void> update(int id, String name) async {
    final res = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/categories/$id'),
      headers: await _headers(),
      body: json.encode({'name': name}),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal update kategori');
    }
  }

  Future<void> delete(int id) async {
    final res = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}/categories/$id'),
      headers: await _headers(),
    );

    // ✅ Terima semua status sukses HTTP
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Gagal hapus kategori');
    }
  }
}
