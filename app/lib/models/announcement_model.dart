class Announcement {
  final int id;
  final String title;
  final String content;
  final DateTime date;
  final String author; // En el backend, esto es el nombre del creador
  bool isImportant;
  bool isRead; // Este campo lo manejaremos localmente en la app

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
    this.isImportant = false,
    this.isRead = false,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['created_at']),
      author: json['created_by_details']?['full_name'] ?? 'Administración',
      // El backend no tiene 'isImportant', lo asumimos como falso por ahora
    );
  }
}
