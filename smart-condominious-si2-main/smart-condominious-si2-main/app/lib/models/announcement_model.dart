// lib/models/announcement_model.dart
class Announcement {
  final int id;
  final String title;
  final String content;
  final String authorName;
  final DateTime createdAt;
  bool isRead; // Para manejar el estado de "leído" localmente

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.createdAt,
    this.isRead = false,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'] ?? 'Sin Título',
      content: json['content'] ?? 'Sin contenido.',
      authorName: json['author_name'] ?? 'Administración',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
