import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/constants/strings.dart';

class TokenManager {
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // New method to check and refresh the access token
  Future<String?> getValidAccessToken() async {
    final accessToken = await getAccessToken();

    if (accessToken != null && !isTokenExpired(accessToken)) {
      return accessToken;
    }

    // If the token is expired, try to refresh it
    final refreshToken = await getRefreshToken();
    if (refreshToken != null) {
      final newAccessToken = await refreshAccessToken(refreshToken);
      print('New access token: $newAccessToken');
      if (newAccessToken != null) {
        await saveAccessToken(newAccessToken);
        return newAccessToken;
      }
    }

    // If refreshing fails, clear tokens
    await clearTokens();
    return null;
  }

  // Helper method to check if a token is expired
  bool isTokenExpired(String token) {
    try {
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
      );
      final expiry = payload['exp'] * 1000; // Convert to milliseconds
      return DateTime.now().millisecondsSinceEpoch > expiry;
    } catch (e) {
      return true; // Assume expired if parsing fails
    }
  }

  // Helper method to refresh the access token
  Future<String?> refreshAccessToken(String refreshToken) async {
    print('Refreshing access token...');
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );

    final _dio = Dio(options);

    try {
      final response = await _dio.post(
        'accounts/login/refresh/', // Endpoint path, baseUrl is already set
        data: json.encode({'refresh': refreshToken}),
      );
      if (response.statusCode == 200) {
        final data =
            response.data is String
                ? json.decode(response.data)
                : response.data;
        return data['access'];
      }
    } catch (e) {
      // Handle errors (e.g., log them)
    }
    return null;
  }
}
