import '../../../../core/network/dio_client.dart';
import '../../domain/entities/dashboard_publisher_entity.dart';

class DashboardPublisherModel extends DashboardPublisherEntity {
  DashboardPublisherModel({
    required super.id,
    required super.name,
    super.logoUrl,
    super.website,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DashboardPublisherModel.fromJson(Map<String, dynamic> json) {
    return DashboardPublisherModel(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      logoUrl: _resolveLogoUrl(json['logo_url']),
      website: json['website']?.toString(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  // penambahan dio client untuk resolve logo url
  static String? _resolveLogoUrl(dynamic value) {
    if (value == null) return null;

    final path = value.toString().trim();
    if (path.isEmpty) return null;

    // Jika backend kirim path relatif (/uploads/...)
    return '${DioClient.dio.options.baseUrl}$path';
  }
}
