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
