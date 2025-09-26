// app/lib/models/announcement_model.dart

class Announcement {
  final int id;
  final String title;
  final String content;
  final DateTime date;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  /// Este es el constructor "mágico" que nos permitirá crear un Announcement
  /// directamente desde el JSON que recibimos de la API.
  /// Se encarga de "mapear" cada campo del JSON a una propiedad de la clase.
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      // El backend envía la fecha como un String (ej: "2023-10-27T10:00:00Z").
      // DateTime.parse() lo convierte a un objeto DateTime que Dart entiende.
      date: DateTime.parse(json['publication_date']),
    );
  }
}
