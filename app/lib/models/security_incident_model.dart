// Este modelo ya no lo usaremos directamente, lo reemplazaremos por 'Task' o 'Feedback' del backend
class ManualIncident {
  // ... (Podemos dejarlo o eliminarlo más adelante)
}

class VisitorLog {
  final int id;
  final String visitorName;
  final String visitorCI;
  final String visitingTo;
  final String? licensePlate; // Campo actualizado
  final DateTime entryTime;
  DateTime? exitTime;

  VisitorLog({
    required this.id,
    required this.visitorName,
    required this.visitorCI,
    required this.visitingTo,
    this.licensePlate,
    required this.entryTime,
    this.exitTime,
  });

  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    return VisitorLog(
      id: json['id'],
      visitorName: json['visitor_name'],
      visitorCI: json['ci'],
      visitingTo: json['resident_name'] ??
          'N/A', // O el campo correcto que venga de la API
      licensePlate: json['license_plate'],
      entryTime: DateTime.parse(json['entry_time']),
      exitTime:
          json['exit_time'] != null ? DateTime.parse(json['exit_time']) : null,
    );
  }
}
