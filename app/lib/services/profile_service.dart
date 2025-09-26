// app/lib/services/profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/auth_service.dart';
import 'package:app/models/profile_models.dart';

class ProfileService {
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api";
  final AuthService _authService = AuthService();

  // --- MÉTODOS DE VEHÍCULOS (CRUD COMPLETO) ---

  Future<List<Vehicle>> getVehicles() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.get(
      Uri.parse('$_baseUrl/vehicles/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los vehículos.');
    }
  }

  Future<Vehicle> addVehicle(
      {required String brand,
      required String model,
      required String color,
      required String licensePlate}) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.post(
      Uri.parse('$_baseUrl/vehicles/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'brand': brand,
        'model': model,
        'color': color,
        'license_plate': licensePlate
      }),
    );
    if (response.statusCode == 201) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar el vehículo.');
    }
  }

  Future<Vehicle> updateVehicle(int vehicleId,
      {required String brand,
      required String model,
      required String color,
      required String licensePlate}) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.put(
      Uri.parse('$_baseUrl/vehicles/$vehicleId/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'brand': brand,
        'model': model,
        'color': color,
        'license_plate': licensePlate
      }),
    );
    if (response.statusCode == 200) {
      return Vehicle.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar el vehículo.');
    }
  }

  Future<void> deleteVehicle(int vehicleId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.delete(
      Uri.parse('$_baseUrl/vehicles/$vehicleId/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el vehículo.');
    }
  }

  // --- MÉTODOS DE MASCOTAS (CRUD COMPLETO) ---

  Future<List<Pet>> getPets() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.get(
      Uri.parse('$_baseUrl/pets/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las mascotas.');
    }
  }

  Future<Pet> addPet(
      {required String name,
      required String species,
      required String breed,
      required String color}) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.post(
      Uri.parse('$_baseUrl/pets/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
          {'name': name, 'species': species, 'breed': breed, 'color': color}),
    );
    if (response.statusCode == 201) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al registrar la mascota.');
    }
  }

  Future<Pet> updatePet(int petId,
      {required String name,
      required String species,
      required String breed,
      required String color}) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.put(
      Uri.parse('$_baseUrl/pets/$petId/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
          {'name': name, 'species': species, 'breed': breed, 'color': color}),
    );
    if (response.statusCode == 200) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar la mascota.');
    }
  }

  Future<void> deletePet(int petId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');
    final response = await http.delete(
      Uri.parse('$_baseUrl/pets/$petId/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la mascota.');
    }
  }
}
