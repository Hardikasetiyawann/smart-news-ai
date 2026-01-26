import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/report_model.dart';

class ReportRemoteDataSource {
  final Dio dio;

  ReportRemoteDataSource({Dio? dio}) : dio = dio ?? DioClient.dio;

  Future<void> createReport(ReportModel report) async {
    try {
      await dio.post('/reports', data: report.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengirim laporan');
    }
  }
}
