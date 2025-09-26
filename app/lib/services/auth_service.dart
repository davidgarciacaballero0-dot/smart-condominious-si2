// app/lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/models/profile_models.dart';

class AuthService {
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api";
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  /// Inicia sesión y devuelve 'true' si es exitoso.
  /// Lanza una excepción si falla.
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/token/'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: _tokenKey, value: data['access']);
      return true; // <-- ESTA ES LA LÍNEA QUE SOLUCIONA EL ERROR
    } else {
      throw Exception(
          'Credenciales incorrectas. Por favor, inténtalo de nuevo.');
    }
  }

  /// Cierra la sesión del usuario eliminando el token.
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Obtiene el token de autenticación del almacenamiento seguro.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Verifica si el usuario tiene un token guardado.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  /// Obtiene los datos del perfil del usuario actualmente autenticado.
  Future<UserProfile> getUserProfile() async {
    final token = await getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.get(
      Uri.parse('$_baseUrl/users/me/'),
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
