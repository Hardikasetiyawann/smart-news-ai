import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/admin_model.dart';

abstract class AuthRemoteDataSource {
  Future<AdminModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AdminModel> login(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.authLoginAdmin}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        final token = body['token'];
        final userData = body['data'];

        return AdminModel.fromJson(userData, token);
      } else {
        throw Exception(body['message'] ?? 'Login gagal');
      }
    } catch (e) {
      // Remote datasource BOLEH lempar exception
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
