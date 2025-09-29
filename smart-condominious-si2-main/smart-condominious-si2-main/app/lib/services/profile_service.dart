// lib/services/profile_service.dart
import 'package:dio/dio.dart';
import '../models/feedback_model.dart'; // <-- Añadimos el nuevo modelo
import '../models/pet_model.dart';
import '../models/vehicle_model.dart';
import 'api_client.dart';

class ProfileService {
  final Dio _dio = ApiClient().dio;

  // --- MÉTODOS PARA VEHÍCULOS (sin cambios) ---
  Future<List<Vehicle>> getMyVehicles() async {
    try {
      final response = await _dio.get('/administration/vehicles/');
      return (response.data as List)
          .map((vehicleJson) => Vehicle.fromJson(vehicleJson))
          .toList();
    } catch (e) {
      print('Error fetching vehicles: $e');
      return [];
    }
  }

  Future<Vehicle?> createVehicle(Map<String, String> vehicleData) async {
    try {
      final response =
          await _dio.post('/administration/vehicles/', data: vehicleData);
      return Vehicle.fromJson(response.data);
    } on DioException catch (e) {
      print('Error creating vehicle: ${e.response?.data}');
      return null;
    }
  }

  Future<bool> deleteVehicle(int vehicleId) async {
    try {
      await _dio.delete('/administration/vehicles/$vehicleId/');
      return true;
    } catch (e) {
      print('Error deleting vehicle: $e');
      return false;
    }
  }

  // --- MÉTODOS PARA MASCOTAS (sin cambios) ---
  Future<List<Pet>> getMyPets() async {
    try {
      final response = await _dio.get('/administration/pets/');
      return (response.data as List)
          .map((petJson) => Pet.fromJson(petJson))
          .toList();
    } catch (e) {
      print('Error fetching pets: $e');
      return [];
    }
  }

  Future<Pet?> createPet(Map<String, String> petData) async {
    try {
      final response = await _dio.post('/administration/pets/', data: petData);
      return Pet.fromJson(response.data);
    } on DioException catch (e) {
      print('Error creating pet: ${e.response?.data}');
      return null;
    }
  }

  Future<bool> deletePet(int petId) async {
    try {
      await _dio.delete('/administration/pets/$petId/');
      return true;
    } catch (e) {
      print('Error deleting pet: $e');
      return false;
    }
  }

  // --- NUEVOS MÉTODOS PARA FEEDBACK ---

  // Obtiene la lista de feedback enviados por el usuario
  Future<List<FeedbackItem>> getMyFeedback() async {
    try {
      final response = await _dio.get('/administration/feedback/my_feedback/');
      return (response.data as List)
          .map((feedbackJson) => FeedbackItem.fromJson(feedbackJson))
          .toList();
    } catch (e) {
      print('Error fetching feedback: $e');
      return [];
    }
  }

  // Crea un nuevo feedback (reclamo o sugerencia)
  Future<bool> createFeedback(
      {required String subject, required String message}) async {
    try {
      await _dio.post(
        '/administration/feedback/',
        data: {
          'subject': subject,
          'message': message,
        },
      );
      return true;
    } on DioException catch (e) {
      print('Error creating feedback: ${e.response?.data}');
      return false;
    }
  }
}
