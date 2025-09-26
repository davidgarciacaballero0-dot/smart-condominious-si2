// app/lib/services/auth_service.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/models/profile_models.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseApiUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api";
  // --- LÍNEA CORREGIDA ---
  final _storage = const FlutterSecureStorage(); // 'Storage' con 'S' mayúscula
  static const String _tokenKey = 'auth_token';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseApiUrl/token/'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: _tokenKey, value: data['access']);
      return true;
    } else {
      throw Exception(
          'Credenciales incorrectas. Por favor, inténtalo de nuevo.');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<UserProfile> getUserProfile() async {
    final token = await getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.get(
      Uri.parse('$_baseApiUrl/administration/users/me/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el perfil del usuario.');
    }
  }
}
