// app/lib/services/announcements_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/auth_service.dart';
import 'package:app/models/announcement_model.dart';

class AnnouncementsService {
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api/administration";
  final AuthService _authService = AuthService();

  /// Obtiene la lista de todos los comunicados desde el backend.
  Future<List<Announcement>> getAnnouncements() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Usuario no autenticado. No se puede obtener el token.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/announcements/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // --- CORRECCIÓN PARA PAGINACIÓN ---
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['results'];

      return jsonList.map((json) => Announcement.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los comunicados.');
    }
  }
}
