import 'package:flutter/material.dart';
import 'models/reservation_model.dart'; // Importa el modelo correcto
import 'booking_page.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final List<CommonArea> _commonAreas = [
    const CommonArea(
        id: '1',
        name: 'Piscina',
        description: 'Piscina semiolímpica con área para niños.',
        imageUrl:
            'https://images.unsplash.com/photo-1575429198348-12b23c9a4731',
        icon: Icons.pool),
    const CommonArea(
        id: '2',
        name: 'Salón de Eventos',
        description: 'Amplio salón para fiestas y reuniones.',
        imageUrl:
            'https://images.unsplash.com/photo-1511795409834-ef04bbd51725',
        icon: Icons.celebration),
    const CommonArea(
        id: '3',
        name: 'Cancha de Tenis',
        description: 'Cancha reglamentaria con iluminación nocturna.',
        imageUrl: 'https://images.unsplash.com/photo-1554167341-79e49a15f336',
        icon: Icons.sports_tennis),
    const CommonArea(
        id: '4',
        name: 'Gimnasio',
        description: 'Equipado con máquinas de última generación.',
        imageUrl:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48',
        icon: Icons.fitness_center),
    const CommonArea(
        id: '5',
        name: 'Churrasquera',
        description: 'Área social con parrilla y mesas al aire libre.',
        imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
        icon: Icons.outdoor_grill),
    const CommonArea(
        id: '6',
        name: 'Cancha de Fútbol',
        description: 'Cancha de césped sintético para fútbol 5.',
        imageUrl: 'https://images.unsplash.com/photo-1551958214-2d5e23a3c686',
        icon: Icons.sports_soccer),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Áreas Comunes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _commonAreas.length,
        itemBuilder: (context, index) {
          final area = _commonAreas[index];
          return CommonAreaCard(commonArea: area);
        },
      ),
    );
  }
}

class CommonAreaCard extends StatelessWidget {
  final CommonArea commonArea;
  const CommonAreaCard({super.key, required this.commonArea});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(commonArea: commonArea),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              commonArea.imageUrl,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  height: 150,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 150,
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commonArea.name,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    commonArea.description,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
