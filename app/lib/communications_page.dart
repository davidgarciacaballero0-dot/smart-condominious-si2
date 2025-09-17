import 'package:flutter/material.dart';
import '../models/announcement_model.dart'; // <-- 1. Importamos nuestro nuevo modelo

class CommunicationsPage extends StatefulWidget {
  const CommunicationsPage({super.key});

  @override
  State<CommunicationsPage> createState() => _CommunicationsPageState();
}

class _CommunicationsPageState extends State<CommunicationsPage> {
  // --- 2. CREAMOS NUESTRA LISTA DE DATOS DE PRUEBA ---
  final List<Announcement> _announcements = [
    Announcement(
      id: '1',
      title: 'Mantenimiento Programado de Ascensores',
      content:
          'Estimados residentes, les informamos que el día 20 de septiembre se realizará el mantenimiento preventivo de los ascensores de la Torre A. El servicio estará suspendido de 9:00 a 13:00. Agradecemos su comprensión.',
      date: DateTime(2025, 9, 15),
      author: 'Administración',
    ),
    Announcement(
      id: '2',
      title: 'Campaña de Fumigación General',
      content:
          'Se llevará a cabo una campaña de fumigación en todas las áreas comunes el próximo sábado 27 de septiembre a partir de las 8:00. Se recomienda mantener ventanas cerradas durante el proceso.',
      date: DateTime(2025, 9, 12),
      author: 'Administración',
    ),
    Announcement(
      id: '3',
      title: 'Recordatorio: Uso Adecuado de la Piscina',
      content:
          'Les recordamos a todos los residentes que el horario de la piscina es de 9:00 a 21:00. Es obligatorio el uso de la ducha antes de ingresar. Por favor, sigamos las normas para el disfrute de todos.',
      date: DateTime(2025, 9, 10),
      author: 'Comité de Convivencia',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
      ),
      // --- 3. CONSTRUIMOS LA LISTA VISUAL ---
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return AnnouncementCard(announcement: announcement);
        },
      ),
    );
  }
}

// --- 4. WIDGET REUTILIZABLE PARA CADA COMUNICADO ---
class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del comunicado
            Text(
              announcement.title,
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            // Autor y Fecha
            Text(
              'Publicado por ${announcement.author} el ${announcement.date.day}/${announcement.date.month}/${announcement.date.year}',
              style: textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12.0),
            // Contenido del comunicado
            Text(
              announcement.content,
              style: textTheme.bodyLarge,
              maxLines: 3, // Mostramos solo un extracto
              overflow:
                  TextOverflow.ellipsis, // Añade "..." si el texto es muy largo
            ),
            const SizedBox(height: 8.0),
            // Botón para leer más
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Viendo comunicado: ${announcement.title}')),
                  );
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
