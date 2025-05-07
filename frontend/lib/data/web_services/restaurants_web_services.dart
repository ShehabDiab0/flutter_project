import 'package:dio/dio.dart';
import 'package:frontend/constants/strings.dart';
import 'token_manager.dart';

class RestaurantsWebServices {
  late Dio _dio;
  final TokenManager tokenManager = TokenManager();

  RestaurantsWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );

    _dio = Dio(options);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await tokenManager.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options); // continue
        },
      ),
    );
  }

  Future<List<dynamic>> getAllRestaurants() async {
    try {
      Response response = await _dio.get(restaurantsURL);
      if (response.statusCode == 200) {
        print(response.data.toString());
        return response.data;
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }
}
