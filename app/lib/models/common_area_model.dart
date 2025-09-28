// lib/models/common_area_model.dart
class CommonArea {
  final int id;
  final String name;
  final String description;
  final int capacity;
  final String imageUrl;

  CommonArea({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    required this.imageUrl,
  });

  factory CommonArea.fromJson(Map<String, dynamic> json) {
    // Aseguramos que la URL de la imagen siempre sea completa
    final imagePath = json['image'] ?? '';
    final baseUrl = "https://smart-condominium-backend-fuab.onrender.com";
    return CommonArea(
      id: json['id'],
      name: json['name'] ?? 'Sin Nombre',
      description: json['description'] ?? '',
      capacity: json['capacity'] ?? 0,
      imageUrl: imagePath.startsWith('http') ? imagePath : "$baseUrl$imagePath",
    );
  }
}
