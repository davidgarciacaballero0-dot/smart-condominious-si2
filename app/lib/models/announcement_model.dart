class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String author;
  bool isImportant; // Si es un comunicado prioritario
  bool isRead; // Si el usuario ya lo leyó

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
    this.isImportant = false, // Por defecto, no es importante
    this.isRead = false, // Por defecto, no está leído
  });
}
