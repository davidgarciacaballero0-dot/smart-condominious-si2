import 'package:flutter/material.dart';

// --- MODELO PARA UN ÁREA COMÚN ---
class CommonArea {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final IconData icon;

  const CommonArea({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
  });
}

// --- MODELO PARA UNA RESERVA ---
class Booking {
  final String id;
  final String commonAreaId;
  final String userId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const Booking({
    required this.id,
    required this.commonAreaId,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}
