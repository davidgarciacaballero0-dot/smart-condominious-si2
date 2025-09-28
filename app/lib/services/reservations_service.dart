// lib/services/reservations_service.dart
// ... (imports y métodos get no cambian)
import 'package:app/services/api_client.dart';
import 'package:dio/dio.dart';

class ReservationsService {
  final Dio _dio = ApiClient().dio;
  // ... getCommonAreas y getMyReservations ...

  // --- MÉTODO CREATE ACTUALIZADO ---
  Future<bool> createReservation(
      {required int commonAreaId,
      required String startTime,
      required String endTime}) async {
    try {
      await _dio.post(
        '/administration/reservations/',
        data: {
          'common_area': commonAreaId,
          'start_time': startTime,
          'end_time': endTime,
          // El backend espera un total_paid, le enviamos un valor temporal.
          // Idealmente, este valor debería venir del CommonArea.
          'total_paid': "0.00",
        },
      );
      return true;
    } on DioException catch (e) {
      print('Error creating reservation: ${e.response?.data}');
      return false;
    }
  }

  // ... (métodos de update y delete no cambian)
}
