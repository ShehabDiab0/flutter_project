import '../web_services/auth_web_services.dart';

class AuthRepository {
  final AuthWebServices authWebServices;

  AuthRepository(this.authWebServices);

  Future<void> registerUser(Map<String, dynamic> userData) {
    return authWebServices.registerUser(userData);
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) {
    return authWebServices.loginUser(email, password);
  }
}
