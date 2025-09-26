// app/lib/communications_page.dart

import 'package:flutter/material.dart';
import 'package:app/models/announcement_model.dart';
import 'package:app/services/announcements_service.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  // Creamos una instancia de nuestro servicio
  final AnnouncementsService _announcementsService = AnnouncementsService();
  // Esta variable guardará la "tarea futura" de obtener los comunicados
  late Future<List<Announcement>> _futureAnnouncements;

  @override
  void initState() {
    super.initState();
    // Iniciamos la llamada a la API tan pronto como la página se carga
    _futureAnnouncements = _announcementsService.getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
      ),
      body: FutureBuilder<List<Announcement>>(
        future:
            _futureAnnouncements, // Le decimos al builder qué futuro observar
        builder: (context, snapshot) {
          // CASO 1: Mientras los datos están cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // CASO 2: Si ocurrió un error
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // CASO 3: Si los datos llegaron pero están vacíos
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay comunicados disponibles.'));
          }
          // CASO 4: ¡Éxito! Los datos están aquí
          else {
            final announcements = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                // Usamos un widget separado para construir cada tarjeta
                return _buildAnnouncementCard(announcement);
              },
            );
          }
        },
      ),
    );
  }

  // Widget para construir la tarjeta de un comunicado
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
            Text(
              // Usamos el paquete 'intl' para formatear la fecha de forma legible
              DateFormat('d \'de\' MMMM, yyyy \'a las\' HH:mm', 'es')
                  .format(announcement.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 24),
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
