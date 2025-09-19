class UserProfile {
  final String name;
  final String unit; // Unidad habitacional, ej: "Uruguay 20"
  final String email;

  const UserProfile({
    required this.name,
    required this.unit,
    required this.email,
  });
}

class Vehicle {
  final String id;
  final String brand; // Marca
  final String model;
  final String plate; // Placa
  final String color;

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.color,
  });
}

class Pet {
  final String id;
  final String name; // <-- ESTA LÍNEA FALTABA O ESTABA INCORRECTA
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
}
