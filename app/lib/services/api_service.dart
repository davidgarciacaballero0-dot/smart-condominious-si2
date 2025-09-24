import 'dart:convert';
import 'package:app/models/announcement_model.dart';
import 'package:app/models/maintenance_task_model.dart';
import 'package:app/models/payment_model.dart';
import 'package:app/models/profile_models.dart';
import 'package:app/models/reservation_model.dart';
import 'package:app/models/security_incident_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://10.0.2.2:8000/api/";
  final _storage = const FlutterSecureStorage();

  // --- MANEJO DE AUTENTICACIÓN ---

  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteAuthToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${_baseUrl}token/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['access'];
      if (token != null) {
        await saveAuthToken(token);
        return {'success': true};
      }
    }
    return {'success': false, 'message': 'Credenciales incorrectas'};
  }

  // --- FINANZAS ---

  Future<List<Payment>> getFinancialFees() async {
    final token = await getAuthToken();
    if (token == null) throw Exception('No autenticado.');

    final url = Uri.parse('${_baseUrl}administration/financial-fees/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Payment.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al cargar datos financieros: ${response.statusCode}');
    }
  }

  // --- RESERVAS DE ÁREAS COMUNES ---

  Future<List<CommonArea>> getCommonAreas() async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/common-areas/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => CommonArea.fromJson(json)).toList();
    } else {
      throw Exception('No se pudieron cargar las áreas comunes');
    }
  }

  Future<bool> createReservation(
      int areaId, String date, String startTime, String endTime) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/reservations/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'common_area': areaId,
        'reservation_date': date,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );
    return response.statusCode == 201;
  }

  // --- GESTIÓN DE VEHÍCULOS ---

  Future<List<Vehicle>> getVehicles() async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/vehicles/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('No se pudieron cargar los vehículos');
    }
  }

  Future<Vehicle> createVehicle(
      String brand, String model, String licensePlate, String color) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/vehicles/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'brand': brand,
        'model': model,
        'license_plate': licensePlate,
        'color': color,
      }),
    );

    if (response.statusCode == 201) {
      return Vehicle.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('No se pudo crear el vehículo');
    }
  }

  Future<Vehicle> updateVehicle(int id, String brand, String model,
      String licensePlate, String color) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/vehicles/$id/');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'brand': brand,
        'model': model,
        'license_plate': licensePlate,
        'color': color,
      }),
    );

    if (response.statusCode == 200) {
      return Vehicle.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('No se pudo actualizar el vehículo');
    }
  }

  Future<bool> deleteVehicle(int id) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/vehicles/$id/');
    final response =
        await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    return response.statusCode == 204;
  }

  // --- GESTIÓN DE MASCOTAS ---

  Future<List<Pet>> getPets() async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/pets/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('No se pudieron cargar las mascotas');
    }
  }

  Future<Pet> createPet(
      String name, String species, String breed, String color) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/pets/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
        'species': species,
        'breed': breed,
        'color': color,
      }),
    );

    if (response.statusCode == 201) {
      return Pet.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('No se pudo crear la mascota');
    }
  }

  Future<Pet> updatePet(
      int id, String name, String species, String breed, String color) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/pets/$id/');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': name,
        'species': species,
        'breed': breed,
        'color': color,
      }),
    );

    if (response.statusCode == 200) {
      return Pet.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('No se pudo actualizar la mascota');
    }
  }

  Future<bool> deletePet(int id) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/pets/$id/');
    final response =
        await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    return response.statusCode == 204;
  }

  // --- ANUNCIOS Y COMUNICADOS ---

  Future<List<Announcement>> getAnnouncements() async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/announcements/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => Announcement.fromJson(json)).toList();
    } else {
      throw Exception('No se pudieron cargar los comunicados');
    }
  }

  // --- REGISTRO DE VISITANTES ---

  Future<List<VisitorLog>> getVisitorLogs() async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/visitor-logs/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => VisitorLog.fromJson(json)).toList();
    } else {
      throw Exception('No se pudo cargar el historial de visitas');
    }
  }

  Future<VisitorLog> createVisitorLog(String visitorName, String ci,
      String residentName, String? licensePlate) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/visitor-logs/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'visitor_name': visitorName,
        'ci': ci,
        'resident_name': residentName,
        'license_plate': licensePlate,
      }),
    );

    if (response.statusCode == 201) {
      return VisitorLog.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('No se pudo registrar la entrada del visitante');
    }
  }

  Future<bool> registerVisitorExit(int logId) async {
    final token = await getAuthToken();
    final url = Uri.parse(
        '${_baseUrl}administration/visitor-logs/$logId/register_exit/');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  Future<List<VisitorLog>> getActiveVisitors() async {
    final token = await getAuthToken();
    final url =
        Uri.parse('${_baseUrl}administration/visitor-logs/active_visitors/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => VisitorLog.fromJson(json)).toList();
    } else {
      throw Exception('No se pudo cargar la lista de visitantes activos');
    }
  }

  // --- GESTIÓN DE TAREAS / INCIDENTES ---

  Future<List<MaintenanceTask>> getTasks() async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/tasks/');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => MaintenanceTask.fromJson(json)).toList();
    } else {
      throw Exception('No se pudieron cargar las tareas/incidentes');
    }
  }

  Future<MaintenanceTask> createTask(
      String title, String description, String priority) async {
    final token = await getAuthToken();
    final url = Uri.parse('${_baseUrl}administration/tasks/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'title': title,
        'description': description,
        'priority': priority.toLowerCase(),
      }),
    );

    if (response.statusCode == 201) {
      return MaintenanceTask.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('No se pudo reportar el incidente');
    }
  }

  Future<bool> updateTaskStatus(int taskId, String newStatus) async {
    final token = await getAuthToken();
    final url =
        Uri.parse('${_baseUrl}administration/tasks/$taskId/update_status/');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'status': newStatus,
      }),
    );
    return response.statusCode == 200;
  }
}
