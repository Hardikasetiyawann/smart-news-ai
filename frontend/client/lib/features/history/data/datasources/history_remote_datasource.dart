import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/reading_history_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<ReadingHistoryModel>> getAllHistory();
  Future<void> deleteHistory(int newsId);
  Future<void> clearHistory();
  Future<void> recordRead(int newsId);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final Dio dio;

  HistoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ReadingHistoryModel>> getAllHistory() async {
    final res = await dio.get('/history');
    final list = res.data['data'] as List;
    return list.map((e) => ReadingHistoryModel.fromJson(e)).toList();
  }

  @override
  Future<void> deleteHistory(int newsId) async {
    await dio.delete('/history/$newsId');
  }

  @override
  Future<void> clearHistory() async {
    await dio.delete('/history');
  }

  @override
  Future<void> recordRead(int newsId) async {
    debugPrint('🔥 CALL POST /history with newsId=$newsId');

    await dio.post(
      '/history',
      data: {'news_id': newsId},
    );
  }
}
