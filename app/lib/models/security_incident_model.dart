// lib/models/security_incident_model.dart

enum UrgencyLevel { baja, media, alta }

class SecurityIncident {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final UrgencyLevel urgency;
  final String reportedBy; // <-- Este campo faltaba

  SecurityIncident({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.urgency,
    required this.reportedBy, // <-- Añadido al constructor
  });
}
