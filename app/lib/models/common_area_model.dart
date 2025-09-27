// En: app/lib/models/common_area_model.dart

class CommonArea {
  final int id;
  final String name;
  final String description;
  final String? imageUrl; // <-- CAMPO AÑADIDO (Opcional)

  CommonArea({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl, // <-- CAMPO AÑADIDO
  });

  factory CommonArea.fromJson(Map<String, dynamic> json) {
    return CommonArea(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      // Leemos el campo de la API, si no viene, será null.
      imageUrl: json['image_url'],
    );
  }
}
