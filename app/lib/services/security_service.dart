// lib/services/security_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/visitor_log_model.dart';
import 'api_client.dart';

class SecurityService {
  final Dio _dio = ApiClient().dio;

  // Obtiene la lista de visitantes que están actualmente dentro del condominio
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

  // Registra la entrada de un nuevo visitante, incluyendo una foto
  Future<bool> createVisitorLog({
    required Map<String, dynamic> visitorData,
    File? visitorPhoto,
  }) async {
    try {
      // Usamos FormData para poder enviar tanto datos de texto como un archivo de imagen
      final formData = FormData.fromMap(visitorData);
      if (visitorPhoto != null) {
        formData.files.add(MapEntry(
          'visitor_photo',
          await MultipartFile.fromFile(visitorPhoto.path),
        ));
      }

      await _dio.post(
        '/administration/visitor-logs/',
        data: formData,
      );
      return true;
    } on DioException catch (e) {
      print('Error creating visitor log: ${e.response?.data}');
      return false;
    }
  }

  // Registra la hora de salida para un visitante activo
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
}
