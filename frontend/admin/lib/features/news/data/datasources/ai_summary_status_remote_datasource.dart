import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/auth_storage.dart';

class AiSummaryStatus {
  final int newsId;
  final bool summarized;
  final String? model;

  AiSummaryStatus({required this.newsId, required this.summarized, this.model});

  factory AiSummaryStatus.fromJson(Map<String, dynamic> json) {
    return AiSummaryStatus(
      newsId: json['id'],
      summarized: json['summarized'],
      model: json['model'],
    );
  }
}

class AiSummaryStatusRemoteDataSource {
  final http.Client client;

  AiSummaryStatusRemoteDataSource(this.client);

  Future<List<AiSummaryStatus>> getStatus() async {
    final token = await AuthStorage.getToken();

    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/ai-summary/status/news'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load AI summary status');
    }

    final body = json.decode(response.body);
    final List list = body['data'];

    return list.map((e) => AiSummaryStatus.fromJson(e)).toList();
  }
}
