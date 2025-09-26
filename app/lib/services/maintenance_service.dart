// app/lib/services/maintenance_service.dart

import 'package:http/http.dart' as http;
import 'package:app/models/task_model.dart';
import 'package:app/services/auth_service.dart';
import 'dart:convert';

class MaintenanceService {
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api/administration";
  final AuthService _authService = AuthService();

  /// Obtiene la lista de tareas asignadas al usuario de mantenimiento.
  Future<List<Task>> getTasks() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.get(
      Uri.parse('$_baseUrl/tasks/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // --- CORRECCIÓN PARA PAGINACIÓN ---
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['results'];

      return jsonList.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las tareas de mantenimiento.');
    }
  }

  /// Actualiza el estado de una tarea específica.
  Future<Task> updateTaskStatus(int taskId, String newStatus) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.patch(
      Uri.parse('$_baseUrl/tasks/$taskId/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': newStatus}),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar el estado de la tarea.');
    }
  }
}
