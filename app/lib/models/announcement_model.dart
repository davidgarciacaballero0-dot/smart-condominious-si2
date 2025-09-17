class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String author; // Quién publicó el comunicado (ej. "Administración")

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
  });
}
