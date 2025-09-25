import 'package:flutter/material.dart';

class CommonArea {
  final int id;
  final String name;
  final String description;
  final String imagePath; // Usaremos una imagen local por ahora
  final IconData icon; // El ícono se queda en la app

  const CommonArea({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.icon,
  });

  factory CommonArea.fromJson(Map<String, dynamic> json) {
    return CommonArea(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      // Mapeamos el nombre del área a un ícono y una imagen local
      imagePath: _getImagePathForArea(json['name']),
      icon: _getIconForArea(json['name']),
    );
  }
}

// Funciones helper para asignar assets locales basados en el nombre del área
String _getImagePathForArea(String areaName) {
  switch (areaName.toLowerCase()) {
    case 'piscina':
      return 'assets/images/areas/piscina.jpg';
    case 'salón de eventos':
      return 'assets/images/areas/salon.jpg';
    case 'cancha de tenis':
      return 'assets/images/areas/tenis.jpg';
    case 'gimnasio':
      return 'assets/images/areas/gimnasio.jpg';
    case 'churrasquera':
      return 'assets/images/areas/churrasquera.jpg';
    case 'cancha de fútbol':
      return 'assets/images/areas/futbol.jpg';
    default:
      return 'assets/images/logo_main.png';
  }
}

IconData _getIconForArea(String areaName) {
  switch (areaName.toLowerCase()) {
    case 'piscina':
      return Icons.pool;
    case 'salón de eventos':
      return Icons.celebration;
    case 'cancha de tenis':
      return Icons.sports_tennis;
    case 'gimnasio':
      return Icons.fitness_center;
    case 'churrasquera':
      return Icons.outdoor_grill;
    case 'cancha de fútbol':
      return Icons.sports_soccer;
    default:
      return Icons.home_work;
  }
}
