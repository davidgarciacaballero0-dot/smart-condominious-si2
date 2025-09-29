// lib/models/task_model.dart

class Task {
  final int id;
  final String title;
  final String description;
  String status; // Lo hacemos modificable para la app
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? 'Sin Título',
      description: json['description'] ?? 'Sin descripción.',
      status: json['status'] ?? 'Pendiente',
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }
}
