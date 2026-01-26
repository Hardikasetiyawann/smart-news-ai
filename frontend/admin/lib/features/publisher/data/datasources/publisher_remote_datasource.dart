import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/publisher_model.dart';

class PublisherRemoteDataSource {
  final http.Client client;
  PublisherRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  // =========================
  // GET ALL
  // =========================
  Future<List<PublisherModel>> getAll() async {
    final response = await client.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.publishers),
      headers: await _headers(),
    );

    final body = jsonDecode(response.body);
    return (body['data'] as List)
        .map((e) => PublisherModel.fromJson(e))
        .toList();
  }

  // =========================
  // CREATE (WEB SAFE)
  // =========================
  Future<void> create({
    required String name,
    String? website,
    XFile? logo,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.baseUrl + ApiConstants.publishers),
    );

    request.headers.addAll(await _headers());
    request.fields['name'] = name;
    if (website != null) request.fields['website'] = website;

    // 🔥 FLUTTER WEB FIX
    if (logo != null) {
      final bytes = await logo.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'logo', // HARUS sama dengan multer.single("logo")
          bytes,
          filename: logo.name,
        ),
      );
    }

    final response = await request.send();
    if (response.statusCode >= 400) {
      throw Exception('Gagal create publisher');
    }
  }

  // =========================
  // UPDATE (WEB SAFE)
  // =========================
  Future<void> update({
    required int id,
    required String name,
    String? website,
    XFile? logo,
  }) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.publishers}/$id"),
    );

    request.headers.addAll(await _headers());
    request.fields['name'] = name;
    if (website != null) request.fields['website'] = website;

    // 🔥 FLUTTER WEB FIX
    if (logo != null) {
      final bytes = await logo.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('logo', bytes, filename: logo.name),
      );
    }

    final response = await request.send();
    if (response.statusCode >= 400) {
      throw Exception('Gagal update publisher');
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<void> delete(int id) async {
    final response = await client.delete(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.publishers}/$id"),
      headers: {...(await _headers()), 'Content-Type': 'application/json'},
    );

    // Terima 200 & 204
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        response.body.isNotEmpty ? response.body : 'Gagal hapus publisher',
      );
    }
  }
}
