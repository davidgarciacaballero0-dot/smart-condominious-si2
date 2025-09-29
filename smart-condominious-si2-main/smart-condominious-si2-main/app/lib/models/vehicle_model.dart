// lib/models/vehicle_model.dart

class Vehicle {
  final int id;
  final String brand; // Marca
  final String model;
  final String color;
  final String licensePlate; // Placa

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.color,
    required this.licensePlate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      color: json['color'] ?? '',
      licensePlate: json['license_plate'] ?? '',
    );
  }
}
