// app/lib/models/common_area_model.dart

class CommonArea {
  final int id;
  final String name;
  final String description;

  CommonArea({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CommonArea.fromJson(Map<String, dynamic> json) {
    return CommonArea(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
