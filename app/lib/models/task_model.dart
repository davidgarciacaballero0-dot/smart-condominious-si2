// app/lib/models/task_model.dart

class Task {
  final int id;
  final String title;
  final String description;
  final String status;
  final DateTime? dueDate; // La fecha puede ser nula

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      // El backend puede no enviar siempre una fecha, así que verificamos si es nula.
      dueDate:
          json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    );
  }
}
