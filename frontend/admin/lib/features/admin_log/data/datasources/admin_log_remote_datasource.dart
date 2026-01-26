import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/admin_log_model.dart';

class AdminLogRemoteDataSource {
  final http.Client client;

  AdminLogRemoteDataSource(this.client);

  Future<Map<String, String>> _headers() async {
    final token = await AuthStorage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<AdminLogModel>> getLogs() async {
    final res = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/admin-logs'),
      headers: await _headers(),
    );

    final body = jsonDecode(res.body);
    final List data = body['data'];

    return data.map((e) => AdminLogModel.fromJson(e)).toList();
  }
}
