// lib/data/mock_data.dart

import '../models/maintenance_task_model.dart';
import '../models/security_incident_model.dart';
import '../models/VisitorLog.dart'; // Asegúrate de que este modelo está corregido

// Lista global de registros de visitantes para simular una base de datos.
final List<VisitorLog> mockVisitorLogs = [
  VisitorLog(
    id: 1, // Corregido a int
    visitorName: 'Ana Pérez',
    ci: '1234567 SC', // Corregido: visitorCI -> ci
    residentName: 'Uruguay 20', // Corregido: visitingTo -> residentName
    entryTime: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  VisitorLog(
    id: 2,
    visitorName: 'Juan Lopez',
    ci: '9876543 CB',
    residentName: 'Paraguay 15',
    licensePlate: '1234ABC',
    entryTime: DateTime.now().subtract(const Duration(minutes: 45)),
  ),
  VisitorLog(
    id: 3,
    visitorName: 'Maria Garcia',
    ci: '5554433 LP',
    residentName: 'Argentina 10',
    entryTime: DateTime.now().subtract(const Duration(days: 1)),
    exitTime: DateTime.now().subtract(const Duration(days: 1, hours: -2)),
  ),
];

// Lista de incidentes reportados manualmente
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
];

// Lista de alertas generadas por IA
final List<SecurityIncident> mockAiAlerts = [
  SecurityIncident(
    id: 'ai1',
    title: 'Persona no reconocida detectada',
    description:
        'Una persona no registrada en la base de datos fue detectada por la cámara 3...',
    date: DateTime.now().subtract(const Duration(minutes: 5)),
    urgency: UrgencyLevel.alta,
    reportedBy: 'IA - Cámara 3',
  ),
];

// Lista de tareas de mantenimiento
final List<MaintenanceTask> mockMaintenanceTasks = [
  MaintenanceTask(
    id: 1, // Corregido a int
    title: 'Reparar luz de pasillo - Piso 5',
    description:
        'La luz del pasillo principal del piso 5, cerca del ascensor A, no enciende. Posiblemente sea el foco.',
    priority: TaskPriority.media,
    status: TaskStatus.pendiente,
    dateReported: DateTime.now().subtract(const Duration(hours: 2)),
    assignedTo: 'Juan Martinez',
  ),
];
