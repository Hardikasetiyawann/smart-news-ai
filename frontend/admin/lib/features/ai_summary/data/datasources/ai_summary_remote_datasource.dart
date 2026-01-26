import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';
import '../models/ai_summary_model.dart';

class AiSummaryRemoteDataSource {
  final http.Client client;

  AiSummaryRemoteDataSource(this.client);

  Future<List<AiSummaryModel>> getAllSummaries() async {
    final token = await AuthStorage.getToken();

    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/ai-summary'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load AI summaries');
    }

    final body = json.decode(response.body);
    final List list = body['data'];

    return list.map((e) => AiSummaryModel.fromJson(e)).toList();
  }
}
