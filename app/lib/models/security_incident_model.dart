// Enum para definir los niveles de urgencia de un incidente
enum UrgencyLevel { baja, media, alta }

class SecurityIncident {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final UrgencyLevel urgency;
  final String reportedBy; // Quién reportó (ej. "IA - Cámara 1" o "Guardia A")

  const SecurityIncident({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.urgency,
    required this.reportedBy,
  });
}
// Archivo: lib/models/security_incident_model.dart

// ... (El enum UrgencyLevel y la clase SecurityIncident no cambian) ...

// --- AÑADE ESTA NUEVA CLASE AL FINAL DEL ARCHIVO ---
class VisitorLog {
  final String id;
  final String visitorName;
  final String visitingTo; // A quién visita
  final String? vehiclePlate; // Placa del vehículo (opcional)
  final DateTime entryTime;
  DateTime? exitTime; // La hora de salida es opcional

  VisitorLog({
    required this.id,
    required this.visitorName,
    required this.visitingTo,
    this.vehiclePlate,
    required this.entryTime,
    this.exitTime,
  });
}
