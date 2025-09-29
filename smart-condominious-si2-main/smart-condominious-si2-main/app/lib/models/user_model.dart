// lib/models/user_model.dart
class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? roleName;
  final String? housingUnitInfo; // <-- NUEVO CAMPO AÑADIDO

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.roleName,
    this.housingUnitInfo, // <-- AÑADIDO AL CONSTRUCTOR
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      roleName: json['role_name'],
    );
  }

  String get fullName => '$firstName $lastName';
}
