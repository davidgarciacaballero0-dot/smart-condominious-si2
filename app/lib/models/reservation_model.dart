// app/lib/models/reservation_model.dart

class Reservation {
  final int id;
  final String commonAreaName;
  final DateTime? date;
  final String timeSlot;
  final String status;

  Reservation({
    required this.id,
    required this.commonAreaName,
    this.date,
    required this.timeSlot,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    String areaName;
    if (json['common_area'] is Map<String, dynamic>) {
      areaName = json['common_area']['name'] ?? 'Área desconocida';
    } else if (json['common_area'] != null) {
      areaName = 'Área ID: ${json['common_area']}';
    } else {
      areaName = 'Área no especificada';
    }

    return Reservation(
      id: json['id'],
      commonAreaName: areaName,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      timeSlot: json['time_slot'] ?? 'No especificado',
      status: json['status'] ?? 'Desconocido',
    );
  }
}
