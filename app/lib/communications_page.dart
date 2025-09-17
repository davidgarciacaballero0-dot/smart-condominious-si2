import 'package:flutter/material.dart';

import '../models/announcement_model.dart';

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  // --- DATOS DE PRUEBA ACTUALIZADOS CON LOS NUEVOS ESTADOS ---
  final List<Announcement> _announcements = [
    Announcement(
      id: '1',
      title: 'Mantenimiento Programado de Ascensores',
      content:
          'Estimados residentes, les informamos que el día 20 de septiembre se realizará el mantenimiento preventivo de los ascensores de la Torre A. El servicio estará suspendido de 9:00 a 13:00. Agradecemos su comprensión.',
      date: DateTime(2025, 9, 15),
      author: 'Administración',
      isImportant: true, // Marcado como importante
      isRead: false,
    ),
    Announcement(
      id: '2',
      title: 'Campaña de Fumigación General',
      content:
          'Se llevará a cabo una campaña de fumigación en todas las áreas comunes el próximo sábado 27 de septiembre a partir de las 8:00. Se recomienda mantener ventanas cerradas durante el proceso.',
      date: DateTime(2025, 9, 12),
      author: 'Administración',
      isRead: false,
    ),
    Announcement(
      id: '3',
      title: 'Recordatorio: Uso Adecuado de la Piscina',
      content:
          'Les recordamos a todos los residentes que el horario de la piscina es de 9:00 a 21:00. Es obligatorio el uso de la ducha antes de ingresar. Por favor, sigamos las normas para el disfrute de todos.',
      date: DateTime(2025, 9, 10),
      author: 'Comité de Convivencia',
      isRead: true, // Marcado como ya leído
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final announcement = _announcements.firstWhere((a) => a.id == id);
      announcement.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return AnnouncementCard(
            announcement: announcement,
            onReadMore: () => _markAsRead(announcement.id),
          );
        },
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onReadMore;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // --- LÓGICA VISUAL PARA LOS ESTADOS ---
    final titleStyle = textTheme.titleMedium?.copyWith(
      fontWeight: announcement.isRead ? FontWeight.normal : FontWeight.bold,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Título del comunicado
                Expanded(
                  child: Text(announcement.title, style: titleStyle),
                ),
                // Indicador de "Sin Leer"
                if (!announcement.isRead)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Autor y Fecha
            Text(
              'Publicado por ${announcement.author} el ${announcement.date.day}/${announcement.date.month}/${announcement.date.year}',
              style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12.0),
            // Etiqueta de "Importante"
            if (announcement.isImportant)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Chip(
                  label: const Text('IMPORTANTE'),
                  backgroundColor: colorScheme.errorContainer,
                  labelStyle: TextStyle(color: colorScheme.onErrorContainer),
                  padding: EdgeInsets.zero,
                ),
              ),
            // Contenido del comunicado
            Text(
              announcement.content,
              style: textTheme.bodyLarge,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            // Botón para leer más
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  onReadMore(); // Llama a la función para marcar como leído
                },
                child: const Text('LEER MÁS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
