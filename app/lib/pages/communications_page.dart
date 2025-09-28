import 'package:app/models/announcement_model.dart';
import 'package:app/services/announcement_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- ESTA ES LA LÍNEA QUE FALTABA

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({Key? key}) : super(key: key);

  @override
  _CommunicationsPageState createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  final _announcementsService = AnnouncementsService();
  Future<List<Announcement>>? _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  void _loadAnnouncements() {
    setState(() {
      _announcementsFuture = _announcementsService.getAnnouncements();
    });
  }

  void _markAsRead(Announcement announcement) {
    setState(() {
      announcement.isRead = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${announcement.title}" marcado como leído.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadAnnouncements(),
        child: FutureBuilder<List<Announcement>>(
          future: _announcementsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                  child: Text('Error al cargar los comunicados.'));
            }
            final announcements = snapshot.data ?? [];
            if (announcements.isEmpty) {
              return const Center(
                  child: Text('No hay comunicados disponibles.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return _buildAnnouncementCard(announcement);
              },
            );
          },
        ),
      ),
    );
  }

  // WIDGET PARA LA TARJETA DE COMUNICADO CON EL NUEVO DISEÑO
  Widget _buildAnnouncementCard(Announcement announcement) {
    // Usaremos un color verde azulado (teal) como distintivo
    final cardColor = Colors.teal[50];
    final accentColor = Colors.teal[800];

    // Formateador para la fecha
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: accentColor!, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del comunicado
            Text(
              announcement.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 8),

            // Información de publicación
            Text(
              'Publicado por ${announcement.authorName} el ${formatter.format(announcement.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            const Divider(height: 20, thickness: 1),

            // Contenido del comunicado
            Text(
              announcement.content,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 16),

            // Botón de "Marcar como leído"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: announcement.isRead
                    ? null
                    : () => _markAsRead(announcement),
                icon: Icon(
                  announcement.isRead
                      ? Icons.check_circle
                      : Icons.mark_chat_read_outlined,
                ),
                label: Text(
                  announcement.isRead ? 'LEÍDO' : 'MARCAR COMO LEÍDO',
                ),
                style: TextButton.styleFrom(
                  foregroundColor:
                      announcement.isRead ? Colors.grey : accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
