// lib/models/pet_model.dart

class Pet {
  final int id;
  final String name;
  final String species; // Especie (ej. Perro, Gato)
  final String breed; // Raza
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
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      color: json['color'] ?? '',
    );
  }
}
