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
