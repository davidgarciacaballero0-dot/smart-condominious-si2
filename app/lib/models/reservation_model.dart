import 'package:flutter/material.dart';

class CommonArea {
  final String id;
  final String name;
  final String description;
  final String imagePath; // <-- CAMBIO DE imageUrl a imagePath
  final IconData icon;

  const CommonArea({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath, // <-- CAMBIO AQUÍ
    required this.icon,
  });
}

// (La clase Booking no cambia)
