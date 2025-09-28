// lib/models/reservation_model.dart
class Reservation {
  final int id;
  final String commonAreaName;
  final String reservationDate;
  final String status;

  Reservation({
    required this.id,
    required this.commonAreaName,
    required this.reservationDate,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    // El backend devuelve el status en inglés, lo traducimos para mostrarlo
    String translatedStatus = 'Pendiente';
    if (json['status'] == 'Approved') {
      translatedStatus = 'Confirmada';
    } else if (json['status'] == 'Cancelled') {
      translatedStatus = 'Cancelada';
    }

    return Reservation(
      id: json['id'],
      // Accedemos al objeto anidado 'common_area' para obtener su nombre
      commonAreaName: json['common_area']?['name'] ?? 'Área desconocida',
      reservationDate: json['reservation_date'],
      status: translatedStatus,
    );
  }
}
