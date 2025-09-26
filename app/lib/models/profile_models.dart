// app/lib/models/profile_models.dart

// No es necesario importar material.dart aquí si no usamos widgets.

class UserProfile {
  final int id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String role; // <-- AÑADE ESTA LÍNEA

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.role, // <-- AÑADE ESTA LÍNEA
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      role: json['role'], // <-- AÑADE ESTA LÍNEA
    );
  }
}

class Vehicle {
  final int id;
  final String brand;
  final String model;
  final String color;
  final String licensePlate; // <-- CAMBIO: 'plate' ahora es 'licensePlate'

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
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
      // Mapeamos 'license_plate' del JSON a nuestra propiedad 'licensePlate'
      licensePlate: json['license_plate'],
    );
  }
}

// En app/lib/models/profile_models.dart
// En app/lib/models/profile_models.dart

class Pet {
  final int id;
  final String name;
  final String species;
  final String breed;
  final String color;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.color,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'] ?? 'Sin nombre',
      species: json['species'] ?? 'No especificado',
      breed: json['breed'] ?? 'No especificado',
      color: json['color'] ?? 'No especificado',
    );
  }
}
