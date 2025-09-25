enum TaskPriority { baja, media, alta }

enum TaskStatus { pendiente, enProgreso, completada }

class MaintenanceTask {
  final int id;
  final String title;
  final String description;
  TaskPriority priority;
  TaskStatus status;
  final DateTime dateReported;
  final String? assignedTo;

  MaintenanceTask({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dateReported,
    this.assignedTo,
  });

  factory MaintenanceTask.fromJson(Map<String, dynamic> json) {
    return MaintenanceTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: _priorityFromString(json['priority']),
      status: _statusFromString(json['status']),
      dateReported: DateTime.parse(json['created_at']),
      assignedTo: json['assigned_to_details']?['full_name'],
    );
  }
}

// Funciones helper para convertir texto a enum
TaskPriority _priorityFromString(String priority) {
  return TaskPriority.values.firstWhere(
    (e) => e.toString() == 'TaskPriority.$priority',
    orElse: () => TaskPriority.baja,
  );
}

TaskStatus _statusFromString(String status) {
  switch (status) {
    case 'pending':
      return TaskStatus.pendiente;
    case 'in_progress':
      return TaskStatus.enProgreso;
    case 'completed':
      return TaskStatus.completada;
    default:
      return TaskStatus.pendiente;
  }
}
