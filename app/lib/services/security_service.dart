// app/lib/services/security_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/visitor_log_model.dart';
import 'package:app/models/feedback_model.dart';
import 'package:app/services/auth_service.dart';

class SecurityService {
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api/administration";
  final AuthService _authService = AuthService();

  Future<List<VisitorLog>> getVisitorLogs() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.get(
      Uri.parse('$_baseUrl/visitor-logs/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['results'];
      return jsonList.map((json) => VisitorLog.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar el historial de visitas.');
    }
  }

  Future<VisitorLog> registerVisitorEntry({
    required String residentName,
    required String visitorFullName,
    required String visitorDocumentNumber,
  }) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.post(
      Uri.parse('$_baseUrl/visitor-logs/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'resident_name': residentName,
        'visitor_full_name': visitorFullName,
        'visitor_document_number': visitorDocumentNumber,
      }),
    );

    if (response.statusCode == 201) {
      return VisitorLog.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar la entrada del visitante.');
    }
  }

  Future<void> registerVisitorExit(int logId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.post(
      Uri.parse('$_baseUrl/visitor-logs/$logId/exit/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al registrar la salida del visitante.');
    }
  }

  Future<FeedbackReport> reportIncident(
      {required String title, required String description}) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.post(
      Uri.parse('$_baseUrl/feedback/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'title': title, 'description': description}),
    );
    if (response.statusCode == 201) {
      return FeedbackReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al reportar el incidente.');
    }
  }
}
