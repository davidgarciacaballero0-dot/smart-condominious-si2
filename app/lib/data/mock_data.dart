import '../models/maintenance_task_model.dart'; // <-- 1. AÑADE ESTA IMPORTACIÓN
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
  // ... (otros incidentes)
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
  // ... (otras alertas)
];

// --- 2. AÑADE ESTA NUEVA LISTA DE TAREAS DE MANTENIMIENTO ---
final List<MaintenanceTask> mockMaintenanceTasks = [
  MaintenanceTask(
    id: 'task1',
    title: 'Reparar luz de pasillo - Piso 5',
    description:
        'La luz del pasillo principal del piso 5, cerca del ascensor A, no enciende. Posiblemente sea el foco.',
    priority: TaskPriority.media,
    status: TaskStatus.pendiente,
    dateReported: DateTime.now().subtract(const Duration(hours: 2)),
    assignedTo: 'Juan Martinez',
  ),
  MaintenanceTask(
    id: 'task2',
    title: 'Mantenimiento preventivo de bomba de agua',
    description:
        'Realizar la revisión y lubricación mensual de la bomba de agua principal del condominio.',
    priority: TaskPriority.alta,
    status: TaskStatus.pendiente,
    dateReported: DateTime.now().subtract(const Duration(days: 1)),
    assignedTo: 'Juan Martinez',
  ),
  MaintenanceTask(
    id: 'task3',
    title: 'Pintar baranda de piscina',
    description:
        'La baranda de metal de la escalera de la piscina muestra signos de óxido y necesita una nueva capa de pintura.',
    priority: TaskPriority.baja,
    status: TaskStatus.completada,
    dateReported: DateTime.now().subtract(const Duration(days: 5)),
    assignedTo: 'Equipo de Mantenimiento',
  ),
  MaintenanceTask(
    id: 'task4',
    title: 'Revisar fuga en garaje subterráneo',
    description:
        'Se reportó una pequeña fuga de agua en el techo del sector -2 del garaje, cerca del espacio B-12.',
    priority: TaskPriority.alta,
    status: TaskStatus.enProgreso,
    dateReported: DateTime.now().subtract(const Duration(hours: 6)),
    assignedTo: 'Juan Martinez',
  ),
];
