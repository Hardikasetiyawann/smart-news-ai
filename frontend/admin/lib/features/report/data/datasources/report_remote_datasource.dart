import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/report_model.dart';

class ReportRemoteDataSource {
  final http.Client client;
  ReportRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  Future<List<ReportModel>> getAll() async {
    final res = await client.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.reports),
      headers: await _headers(),
    );

    final body = jsonDecode(res.body);
    return (body['data'] as List).map((e) => ReportModel.fromJson(e)).toList();
  }

  Future<void> updateStatus(int id, String status) async {
    await client.patch(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.reports}/$id"),
      headers: await _headers(),
      body: {'status': status},
    );
  }

  Future<void> delete(int id) async {
    await client.delete(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.reports}/$id"),
      headers: await _headers(),
    );
  }
}
