// En: app/lib/explore_areas_page.dart (Archivo nuevo)

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:app/models/common_area_model.dart';
import 'package:app/services/reservations_service.dart';
import 'package:app/add_reservation_page.dart';

class ExploreAreasPage extends StatefulWidget {
  const ExploreAreasPage({super.key});

  @override
  State<ExploreAreasPage> createState() => _ExploreAreasPageState();
}

class _ExploreAreasPageState extends State<ExploreAreasPage> {
  final ReservationsService _reservationsService = ReservationsService();

  // Mapa de imágenes locales para usar mientras el backend no las envíe
  final Map<String, String> _localImages = {
    'piscina': 'assets/images/areas/piscina.jpg',
    'salón de eventos': 'assets/images/areas/salon.jpg',
    'churrasquera': 'assets/images/areas/churrasquera.jpg',
    'gimnasio': 'assets/images/areas/gimnasio.jpg',
    'cancha de tenis': 'assets/images/areas/tenis.jpg',
    'cancha de futbol': 'assets/images/areas/futbol.jpg',
  };

  // Función inteligente para decidir qué imagen mostrar
  String _getImageForArea(CommonArea area) {
    // Prioridad 1: Usar la URL de la API si existe
    if (area.imageUrl != null && area.imageUrl!.isNotEmpty) {
      // Aquí usaríamos NetworkImage, pero por ahora seguimos con AssetImage
      // return area.imageUrl!;
    }

    // Prioridad 2: Buscar una imagen local que coincida con el nombre
    final key = area.name.toLowerCase();
    // Esto buscará si el nombre del área contiene alguna de las claves
    for (var localKey in _localImages.keys) {
      if (key.contains(localKey)) {
        return _localImages[localKey]!;
      }
    }

    // Prioridad 3: Una imagen por defecto si no hay coincidencias
    return 'assets/images/logo_main.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Áreas Comunes'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<CommonArea>>(
        future: _reservationsService.getCommonAreas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay áreas comunes disponibles.'));
          }

          final areas = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            itemCount: areas.length,
            itemBuilder: (context, index) {
              final area = areas[index];
              return _buildAreaCard(context, area);
            },
          );
        },
      ),
    );
  }

  Widget _buildAreaCard(BuildContext context, CommonArea area) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // Navegamos a la página del formulario, pasándole el área seleccionada
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReservationPage(commonArea: area),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                _getImageForArea(area),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 40, color: Colors.grey);
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                area.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
