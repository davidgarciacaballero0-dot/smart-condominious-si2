class UserProfile {
  final String name;
  final String unit;
  final String email;

  const UserProfile({
    required this.name,
    required this.unit,
    required this.email,
  });

  // Factory para crear un UserProfile desde JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['full_name'] ?? 'Nombre no disponible',
      unit: json['residential_unit']?['identifier'] ?? 'Unidad no asignada',
      email: json['email'] ?? '',
    );
  }
}

class Vehicle {
  final int id;
  final String brand;
  final String model;
  final String licensePlate; // Campo actualizado
  final String color;

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.licensePlate,
    required this.color,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      licensePlate: json['license_plate'],
      color: json['color'],
    );
  }
}

class Pet {
  final int id;
  final String name;
  final String species;
  final String breed;
  final String color;

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.color,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      color: json['color'],
    );
  }
}
