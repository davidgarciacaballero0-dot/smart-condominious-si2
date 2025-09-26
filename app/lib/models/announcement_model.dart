// app/lib/models/announcement_model.dart

class Announcement {
  final int id;
  final String title;
  final String content;
  final DateTime? date; // La fecha también puede ser nula

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    this.date,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'] ?? 'Sin título',
      content: json['content'] ?? 'Sin contenido',
      date: json['publication_date'] != null
          ? DateTime.parse(json['publication_date'])
          : null,
    );
  }
}
