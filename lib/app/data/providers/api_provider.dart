import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../services/storage_service.dart';
import '../../config/app_config.dart';

class APIProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<Response> login({
    required String username,
    required String password,
    required String platform,
  }) async {
    try {
      // ✅ Corrected API endpoint
      final response = await _dio.post(
        '/account/auth/login',
        data: {
          'username': username,
          'password': password,
          'platform': platform,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          "Server error: ${e.response?.statusCode} - ${e.response?.data}",
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  // ✅ Get Products
  Future<Response> getProducts() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.readToken();
      
      print('🔑 Token for products API: ${token?.substring(0, 20)}...');

      return await _dio.get(
        '/admin/products',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // ✅ Include JWT token
          },
        ),
      );
    } catch (e) {
      print('❌ Products API Error: $e');
      rethrow;
    }
  }
}
