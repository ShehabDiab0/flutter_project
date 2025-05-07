import 'package:dio/dio.dart';
import 'package:frontend/constants/strings.dart';
import 'token_manager.dart';

class ProductsWebServices {
  late Dio _dio;
  final TokenManager tokenManager = TokenManager();

  ProductsWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    );

    _dio = Dio(options);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await tokenManager.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options); // Continue
        },
      ),
    );
  }

  Future<List<dynamic>> fetchProducts(int restaurantId) async {
    try {
      final url = '/restaurants/$restaurantId/products/';
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        print('Products fetched successfully: ${response.data}');
        return response.data;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
