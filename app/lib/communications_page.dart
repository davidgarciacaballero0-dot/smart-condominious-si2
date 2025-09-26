// app/lib/communications_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/announcement_model.dart';
import 'package:app/services/announcements_service.dart';
import 'package:intl/intl.dart';

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  final AnnouncementsService _announcementsService = AnnouncementsService();
  late Future<List<Announcement>> _futureAnnouncements;

  @override
  void initState() {
    super.initState();
    _futureAnnouncements = _announcementsService.getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
      ),
      body: FutureBuilder<List<Announcement>>(
        future: _futureAnnouncements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay comunicados disponibles.'));
          } else {
            final announcements = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return _buildAnnouncementCard(announcement);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (announcement.date !=
                null) // Solo muestra la fecha si no es nula
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  DateFormat('d \'de\' MMMM, yyyy \'a las\' HH:mm', 'es')
                      .format(announcement.date!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const Divider(),
            Text(
              announcement.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
