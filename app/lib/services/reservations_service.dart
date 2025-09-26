// app/lib/services/reservations_service.dart

import 'package:http/http.dart' as http;
import 'package:app/services/auth_service.dart';
import 'package:app/models/reservation_model.dart';
import 'package:app/models/common_area_model.dart';
import 'dart:convert';

class ReservationsService {
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api/administration";

  final AuthService _authService = AuthService();

  Future<List<Reservation>> getReservations() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.get(
      Uri.parse('$_baseUrl/reservations/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      // --- CAMBIO CLAVE AQUÍ ---
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList =
          jsonResponse['results']; // Extraemos la lista de 'results'
      return jsonList.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las reservas.');
    }
  }

  Future<List<CommonArea>> getCommonAreas() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.get(
      Uri.parse('$_baseUrl/common-areas/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CommonArea.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las áreas comunes.');
    }
  }

  Future<void> createReservation(
      {required int commonAreaId,
      required String date,
      required String timeSlot}) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.post(
      Uri.parse('$_baseUrl/reservations/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
          {'common_area': commonAreaId, 'date': date, 'time_slot': timeSlot}),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al crear la reserva.');
    }
  }

  /// Envía una petición para eliminar/cancelar una reserva.
  Future<void> cancelReservation(int reservationId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.delete(
      Uri.parse('$_baseUrl/reservations/$reservationId/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      // 204 No Content
      throw Exception('Error al cancelar la reserva.');
    }
  }
}
