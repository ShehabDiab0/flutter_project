import 'package:dio/dio.dart';
import 'package:frontend/constants/strings.dart';

class AuthWebServices {
  late Dio _dio;

  AuthWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );

    _dio = Dio(options);
  }

  Future<void> registerUser(Map<String, dynamic> userData) async {
    // print(_dio.options.baseUrl);
    final response = await _dio.post(registerURL, data: userData);
    return response.data;
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    // print(_dio.options.baseUrl);
    final response = await _dio.post(
      loginURL,
      data: {'email': email, 'password': password},
    );
    return response.data;
  }
}
