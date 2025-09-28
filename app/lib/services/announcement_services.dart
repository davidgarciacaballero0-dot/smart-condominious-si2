// lib/services/announcements_service.dart
import 'package:dio/dio.dart';
import '../models/announcement_model.dart';
import 'api_client.dart';

class AnnouncementsService {
  final Dio _dio = ApiClient().dio;

  // Obtener la lista de todos los comunicados
  Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await _dio.get('/administration/announcements/');
      // El backend devuelve un objeto con "results", extraemos esa lista.
      final List<dynamic> results = response.data['results'] ?? response.data;
      return results
          .map((announcementJson) => Announcement.fromJson(announcementJson))
          .toList();
    } catch (e) {
      print('Error fetching announcements: $e');
      return [];
    }
  }
}