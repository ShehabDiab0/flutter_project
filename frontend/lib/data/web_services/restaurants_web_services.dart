import 'package:dio/dio.dart';
import 'package:frontend/constants/strings.dart';

class RestaurantsWebServices {
  // This class will contain methods to interact with the restaurant API
  // For example, fetching a list of restaurants, getting details of a specific restaurant, etc.
  late Dio _dio;

  RestaurantsWebservices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );

    _dio = Dio(options);
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
