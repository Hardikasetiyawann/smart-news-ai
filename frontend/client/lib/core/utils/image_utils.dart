import '../network/dio_client.dart';

String resolveImageUrl(String? url) {
  if (url == null || url.isEmpty) return '';

  // sudah absolute
  if (url.startsWith('http')) return url;

  final baseUrl = DioClient.dio.options.baseUrl;

  // HAPUS trailing /api
  final cleanBaseUrl = baseUrl.endsWith('/api')
      ? baseUrl.substring(0, baseUrl.length - 4)
      : baseUrl;

  return '$cleanBaseUrl$url';
}
