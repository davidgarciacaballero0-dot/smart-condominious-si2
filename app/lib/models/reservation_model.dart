// app/lib/models/reservation_model.dart

class Reservation {
  final int id;
  final String commonAreaName;
  final DateTime date;
  final String timeSlot;
  final String status;

  Reservation({
    required this.id,
    required this.commonAreaName,
    required this.date,
    required this.timeSlot,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      commonAreaName: json['common_area'] != null
          ? json['common_area']['name']
          : 'Área desconocida',
      date: DateTime.parse(json['date']),
      timeSlot: json['time_slot'],
      status: json['status'],
    );
  }
}
