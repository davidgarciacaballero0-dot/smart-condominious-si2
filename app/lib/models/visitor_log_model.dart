// lib/models/visitor_log_model.dart

class VisitorLog {
  final int id;
  final String fullName;
  final String dni;
  final String? company;
  final String reasonForVisit;
  final String housingUnit;
  final String entryTime;
  final String? exitTime;
  final String status;
  final String? visitorPhotoUrl; // <-- NUEVO CAMPO PARA LA FOTO

  VisitorLog({
    required this.id,
    required this.fullName,
    required this.dni,
    this.company,
    required this.reasonForVisit,
    required this.housingUnit,
    required this.entryTime,
    this.exitTime,
    required this.status,
    this.visitorPhotoUrl, // <-- AÑADIDO AL CONSTRUCTOR
  });

  factory VisitorLog.fromJson(Map<String, dynamic> json) {
    String unitInfo = 'N/A';
    if (json['housing_unit_details'] != null) {
      final details = json['housing_unit_details'];
      unitInfo =
          'Bloque ${details['block_number']} - Unidad ${details['unit_number']}';
    }

    return VisitorLog(
      id: json['id'],
      fullName: json['full_name'] ?? 'Sin Nombre',
      dni: json['dni'] ?? 'Sin DNI',
      company: json['company'],
      reasonForVisit: json['reason_for_visit'] ?? '',
      housingUnit: unitInfo,
      entryTime: json['entry_time'] ?? '',
      exitTime: json['exit_time'],
      status: json['status'] ?? 'Desconocido',
      // El backend devuelve la URL de la foto si existe
      visitorPhotoUrl: json['visitor_photo'],
    );
  }
}
