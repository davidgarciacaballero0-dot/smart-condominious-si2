// lib/services/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Crea una instancia del almacenamiento seguro
  final _storage = const FlutterSecureStorage();

  // Guarda los tokens de acceso y de refresco
  Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // Lee el token de acceso guardado
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Borra todos los datos guardados (para el logout)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
