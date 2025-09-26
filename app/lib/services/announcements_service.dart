// app/lib/services/announcements_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/announcement_model.dart';
import 'package:app/services/auth_service.dart';

class AnnouncementsService {
  final String _baseUrl = "http://10.0.2.2:8000/api";
  final AuthService _authService = AuthService();

  /// Obtiene la lista de todos los comunicados desde el backend.
  /// Requiere un token de autenticación válido.
  Future<List<Announcement>> getAnnouncements() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Usuario no autenticado. No se puede obtener el token.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/announcements/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // Adjuntamos el token en la cabecera de autorización.
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Si el servidor responde correctamente (OK)
      final List<dynamic> jsonList = jsonDecode(response.body);

      // Usamos el constructor .fromJson que creamos en el modelo
      // para convertir cada elemento de la lista JSON en un objeto Announcement.
      return jsonList.map((json) => Announcement.fromJson(json)).toList();
    } else {
      // Si hay un error, lanzamos una excepción para manejarla en la UI.
      throw Exception('Error al cargar los comunicados.');
    }
  }
}
