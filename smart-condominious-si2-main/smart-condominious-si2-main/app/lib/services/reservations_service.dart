// lib/services/reservations_service.dart
import 'package:dio/dio.dart';
import '../models/common_area_model.dart';
import '../models/reservation_model.dart';
import 'api_client.dart';

class ReservationsService {
  final Dio _dio = ApiClient().dio;

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

  Future<bool> createReservation({
    required int commonAreaId,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await _dio.post(
        '/administration/reservations/',
        data: {
          'common_area': commonAreaId,
          'start_time': startTime,
          'end_time': endTime,
          'total_paid': "0.00",
        },
      );
      return true;
    } on DioException catch (e) {
      print('Error creating reservation: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> updateReservationStatus(
      {required int reservationId, required String newStatus}) async {
    try {
      await _dio.patch(
        '/administration/reservations/$reservationId/',
        data: {'status': newStatus},
      );
      return true;
    } on DioException catch (e) {
      print('Error updating reservation status: ${e.response?.data}');
      return false;
    }
  }
}
