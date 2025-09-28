// lib/services/reservations_service.dart
import 'package:dio/dio.dart';
import '../models/common_area_model.dart';
import '../models/reservation_model.dart';
import 'api_client.dart';

class ReservationsService {
  final Dio _dio = ApiClient().dio;

  // ... (los métodos getCommonAreas y getMyReservations no cambian) ...
  Future<List<CommonArea>> getCommonAreas() async {
    try {
      final response = await _dio.get('/administration/common-areas/');
      return (response.data as List)
          .map((areaJson) => CommonArea.fromJson(areaJson))
          .toList();
    } catch (e) {
      print('Error fetching common areas: $e');
      return [];
    }
  }

  Future<List<Reservation>> getMyReservations() async {
    try {
      final response =
          await _dio.get('/administration/reservations/my_reservations/');
      return (response.data as List)
          .map((resJson) => Reservation.fromJson(resJson))
          .toList();
    } catch (e) {
      print('Error fetching my reservations: $e');
      return [];
    }
  }

  Future<bool> createReservation(
      {required int commonAreaId, required String date}) async {
    try {
      await _dio.post(
        '/administration/reservations/',
        data: {
          'common_area': commonAreaId,
          'reservation_date': date,
        },
      );
      return true;
    } on DioException catch (e) {
      print('Error creating reservation: ${e.response?.data}');
      return false;
    }
  }

  // --- NUEVOS MÉTODOS ---

  // MÉTODO PARA ACTUALIZAR UNA RESERVA (SOLO EL ESTADO)
  Future<bool> updateReservationStatus(
      {required int reservationId, required String newStatus}) async {
    try {
      await _dio.patch(
        '/administration/reservations/$reservationId/',
        data: {'status': newStatus},
      );
      return true; // Actualización exitosa
    } on DioException catch (e) {
      print('Error updating reservation status: ${e.response?.data}');
      return false;
    }
  }

  // MÉTODO PARA ELIMINAR UNA RESERVA
  Future<bool> deleteReservation({required int reservationId}) async {
    try {
      await _dio.delete('/administration/reservations/$reservationId/');
      return true; // Eliminación exitosa
    } on DioException catch (e) {
      print('Error deleting reservation: ${e.response?.data}');
      return false;
    }
  }
}
