import 'package:flutter/foundation.dart';
import '../../../../core/network/dio_client.dart';
import '../models/publisher_news_model.dart';

class PublisherRemoteDataSource {
  const PublisherRemoteDataSource();

  // =====================
  // SAFE RESPONSE LIST
  // =====================
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data['data'] is List) {
      return data['data'];
    }
    return [];
  }

  Future<List<PublisherNewsModel>> getNewsByPublisherId(int publisherId) async {
    try {
      final response = await DioClient.dio.get('/news/publisher/$publisherId');

      if (kDebugMode) {
        debugPrint('Publisher response: ${response.data}');
      }

      final list = _extractList(response.data);

      return list.map((e) => PublisherNewsModel.fromJson(e)).toList();
    } catch (e, s) {
      debugPrint('ERROR getNewsByPublisherId');
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }
}
