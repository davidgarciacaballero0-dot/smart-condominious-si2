// ignore_for_file: deprecated_member_use, unused_element

import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import 'services/api_service.dart';

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Announcement>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = _apiService.getAnnouncements();
  }

  void _markAsRead(Announcement announcement) {
    setState(() {
      // En la versión con datos de prueba, esto solo afecta el estado local
      announcement.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
      ),
      body: FutureBuilder<List<Announcement>>(
        future: _announcementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay comunicados disponibles.'));
          }

          final announcements = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return AnnouncementCard(
                announcement: announcement,
                onReadMore: () => _markAsRead(announcement),
              );
            },
          );
        },
      ),
    );
  }
}

// La clase AnnouncementCard no necesita grandes cambios, solo los visuales que ya tenías
class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onReadMore;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onReadMore,
  });

  Color _getCardColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (announcement.isImportant && !announcement.isRead) {
      return colorScheme.errorContainer.withOpacity(0.3);
    }
    if (announcement.isRead) {
      return Colors.grey.shade200;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = _getCardColor(context);

    return Card(
      color: cardColor,
      elevation: announcement.isRead ? 1 : 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: announcement.isImportant
                      ? colorScheme.error
                      : colorScheme.primary,
                  width: 5.0,
                ),
              ),
            ),
            child: Text(
              announcement.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight:
                    announcement.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text(
                  'Publicado por ${announcement.author} el ${announcement.date.day}/${announcement.date.month}/${announcement.date.year}',
                  style: textTheme.bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 12.0),
                Text(
                  announcement.content,
                  style: textTheme.bodyLarge,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                if (!announcement.isRead)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onReadMore,
                      child: const Text('MARCAR COMO LEÍDO'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
