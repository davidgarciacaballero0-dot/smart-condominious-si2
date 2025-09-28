// lib/models/reservation_model.dart

class Reservation {
  final int id;
  final String commonAreaName;
  final String reservationDate;
  final String status;
  final String? startTime;
  final String? endTime;

  Reservation({
    required this.id,
    required this.commonAreaName,
    required this.reservationDate,
    required this.status,
    this.startTime,
    this.endTime,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    String translatedStatus = 'Pendiente';
    if (json['status'] == 'Approved') {
      translatedStatus = 'Confirmada';
    } else if (json['status'] == 'Cancelled') {
      translatedStatus = 'Cancelada';
    }

    return Reservation(
      id: json['id'],
      commonAreaName: json['common_area']?['name'] ?? 'Área desconocida',
      // Usamos start_time si existe, si no, usamos reservation_date como fallback
      reservationDate: json['start_time'] != null
          ? json['start_time'].split('T').first
          : (json['reservation_date'] ?? ''),
      status: translatedStatus,
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
