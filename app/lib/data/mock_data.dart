import '../models/security_incident_model.dart';

// Lista global de registros de visitantes para simular una base de datos.
final List<VisitorLog> mockVisitorLogs = [
  VisitorLog(
    id: '1',
    visitorName: 'Ana Pérez',
    visitorCI: '1234567 SC',
    visitingTo: 'Uruguay 20',
    entryTime: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  VisitorLog(
    id: '2',
    visitorName: 'Juan Lopez',
    visitorCI: '9876543 CB',
    visitingTo: 'Paraguay 15',
    vehiclePlate: '1234ABC',
    entryTime: DateTime.now().subtract(const Duration(minutes: 45)),
  ),
  VisitorLog(
    id: '3',
    visitorName: 'Maria Garcia',
    visitorCI: '5554433 LP',
    visitingTo: 'Argentina 10',
    entryTime: DateTime.now().subtract(const Duration(days: 1)),
    exitTime: DateTime.now().subtract(const Duration(days: 1, hours: -2)),
  ),
];
final List<SecurityIncident> mockIncidents = [
  SecurityIncident(
    id: '1',
    title: 'Vehículo mal estacionado',
    description:
        'El vehículo Toyota Corolla con placa 2457GTH se encuentra bloqueando una salida de emergencia.',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    urgency: UrgencyLevel.media,
    reportedBy: 'Guardia A',
  ),
  SecurityIncident(
    id: '2',
    title: 'Mascota sin correa en área común',
    description:
        'Un perro de raza Golden Retriever fue visto corriendo sin supervisión cerca del área de la piscina.',
    date: DateTime.now().subtract(const Duration(days: 1)),
    urgency: UrgencyLevel.baja,
    reportedBy: 'Carlos Rojas',
  ),
  SecurityIncident(
    id: '3',
    title: 'Intento de acceso no autorizado',
    description:
        'Un individuo desconocido intentó ingresar por la puerta trasera sin registrarse. Fue interceptado.',
    date: DateTime.now().subtract(const Duration(minutes: 25)),
    urgency: UrgencyLevel.alta,
    reportedBy: 'Guardia B',
  ),
];
