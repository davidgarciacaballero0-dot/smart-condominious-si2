// lib/services/api_client.dart
import 'package:dio/dio.dart';
import 'secure_storage.dart'; // Lo crearemos a continuación

class ApiClient {
  final Dio _dio = Dio();
  // Helper para el almacenamiento seguro
  final SecureStorage _secureStorage = SecureStorage();

  // URL base de tu backend
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api";

  ApiClient() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Añade el token a cada petición automáticamente
          final accessToken = await _secureStorage.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
