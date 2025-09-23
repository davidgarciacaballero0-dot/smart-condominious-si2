enum TaskPriority { baja, media, alta }

enum TaskStatus { pendiente, enProgreso, completada }

class MaintenanceTask {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  TaskStatus status; // Propiedad "status" ya no es final
  final DateTime dateReported;
  final String assignedTo;

  MaintenanceTask({
    required this.id,
    required this.title,
    required this.description,
    this.priority = TaskPriority.media,
    this.status = TaskStatus.pendiente,
    required this.dateReported,
    required this.assignedTo,
  });
}
