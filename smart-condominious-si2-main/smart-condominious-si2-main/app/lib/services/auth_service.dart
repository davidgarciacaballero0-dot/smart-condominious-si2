// lib/services/auth_service.dart
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/user_model.dart';
import 'secure_storage.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;
  final SecureStorage _secureStorage = SecureStorage();

  Future<User?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/token/',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];
        await _secureStorage.saveTokens(
            accessToken: accessToken, refreshToken: refreshToken);
        return await getMe();
      }
    } on DioException catch (e) {
      print("Error en login: ${e.response?.data}");
      return null;
    }
    return null;
  }

  Future<User?> getMe() async {
    try {
      final response = await _dio.get('/administration/users/me/');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } on DioException catch (e) {
      print("Error obteniendo datos del usuario: ${e.response?.data}");
    }
    return null;
  }

  Future<String?> getToken() async {
    return await _secureStorage.getAccessToken();
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }
}
