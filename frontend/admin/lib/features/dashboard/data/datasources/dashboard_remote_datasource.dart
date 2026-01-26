import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';

class DashboardRemoteDataSource {
  final http.Client client;

  DashboardRemoteDataSource({required this.client});

  Future<Map<String, dynamic>> fetchDashboard() async {
    final token = await AuthStorage.getToken();

    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDashboard}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return body['data'];
    } else {
      throw Exception(body['message'] ?? 'Gagal memuat dashboard');
    }
  }
}
