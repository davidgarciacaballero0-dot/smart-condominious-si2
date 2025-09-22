import 'package:flutter/material.dart';

import '../models/reservation_model.dart';
import 'booking_page.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  // --- LISTA DE DATOS ACTUALIZADA CON RUTAS LOCALES ---
  final List<CommonArea> _commonAreas = [
    const CommonArea(
        id: '1',
        name: 'Piscina',
        description: 'Piscina semiolímpica con área para niños.',
        imagePath: 'assets/images/areas/piscina.jpg',
        icon: Icons.pool),
    const CommonArea(
        id: '2',
        name: 'Salón de Eventos',
        description: 'Amplio salón para fiestas y reuniones.',
        imagePath: 'assets/images/areas/salon.jpg',
        icon: Icons.celebration),
    const CommonArea(
        id: '3',
        name: 'Cancha de Tenis',
        description: 'Cancha reglamentaria con iluminación nocturna.',
        imagePath: 'assets/images/areas/tenis.jpg',
        icon: Icons.sports_tennis),
    const CommonArea(
        id: '4',
        name: 'Gimnasio',
        description: 'Equipado con máquinas de última generación.',
        imagePath: 'assets/images/areas/gimnasio.jpg',
        icon: Icons.fitness_center),
    const CommonArea(
        id: '5',
        name: 'Churrasquera',
        description: 'Área social con parrilla y mesas al aire libre.',
        imagePath: 'assets/images/areas/churrasquera.jpg',
        icon: Icons.outdoor_grill),
    const CommonArea(
        id: '6',
        name: 'Cancha de Fútbol',
        description: 'Cancha de césped sintético para fútbol 5.',
        imagePath: 'assets/images/areas/futbol.jpg',
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
            // --- CAMBIO DE Image.network a Image.asset ---
            Image.asset(
              commonArea.imagePath,
              height: 150,
              fit: BoxFit.cover,
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
