// lib/services/security_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/task_model.dart'; // <-- Añadimos el nuevo modelo de tareas
import '../models/visitor_log_model.dart';
import 'api_client.dart';

class SecurityService {
  final Dio _dio = ApiClient().dio;

  // --- MÉTODOS PARA VISITANTES (sin cambios) ---
  Future<List<VisitorLog>> getActiveVisitors() async {
    try {
      final response =
          await _dio.get('/administration/visitor-logs/active_visitors/');
      return (response.data as List)
          .map((visitorJson) => VisitorLog.fromJson(visitorJson))
          .toList();
    } catch (e) {
      print('Error fetching active visitors: $e');
      return [];
    }
  }

  Future<List<VisitorLog>> getVisitorHistory() async {
    try {
      final response = await _dio.get('/administration/visitor-logs/');
      final List<dynamic> results = response.data['results'] ?? response.data;
      return results
          .map((visitorJson) => VisitorLog.fromJson(visitorJson))
          .toList();
    } catch (e) {
      print('Error fetching visitor history: $e');
      return [];
    }
  }

  Future<bool> createVisitorLog({
    required Map<String, dynamic> visitorData,
    File? visitorPhoto,
  }) async {
    try {
      final formData = FormData.fromMap(visitorData);
      if (visitorPhoto != null) {
        formData.files.add(MapEntry(
          'visitor_photo',
          await MultipartFile.fromFile(visitorPhoto.path),
        ));
      }
      await _dio.post('/administration/visitor-logs/', data: formData);
      return true;
    } on DioException catch (e) {
      print('Error creating visitor log: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> registerVisitorExit(int visitorLogId) async {
    try {
      await _dio
          .post('/administration/visitor-logs/$visitorLogId/register_exit/');
      return true;
    } on DioException catch (e) {
      print('Error registering visitor exit: ${e.response?.data}');
      return false;
    }
  }

  // --- NUEVOS MÉTODOS PARA TAREAS ---

  // Obtiene la lista de tareas asignadas al usuario logueado
  Future<List<Task>> getMyTasks() async {
    try {
      final response = await _dio.get('/administration/tasks/my_tasks/');
      return (response.data as List)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();
    } catch (e) {
      print('Error fetching my tasks: $e');
      return [];
    }
  }

  // Actualiza el estado de una tarea específica
  Future<bool> updateTaskStatus(int taskId, String newStatus) async {
    try {
      await _dio.patch(
        '/administration/tasks/$taskId/',
        data: {'status': newStatus},
      );
      return true;
    } on DioException catch (e) {
      print('Error updating task status: ${e.response?.data}');
      return false;
    }
  }
}
