// app/lib/services/finances_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/auth_service.dart';
import 'package:app/models/payment_model.dart';

class FinancesService {
  final String _baseUrl =
      "https://smart-condominium-backend-fuab.onrender.com/api/administration";
  final AuthService _authService = AuthService();

  /// Obtiene la lista de cuotas financieras, con un filtro opcional por estado.
  Future<List<FinancialFee>> getFinancialFees({String? status}) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Usuario no autenticado.');
    }

    // --- LÓGICA DE FILTRADO CORREGIDA Y VERIFICADA ---
    // Construimos la URL base
    var uri = Uri.parse('$_baseUrl/financial-fees/');

    // Si se proporciona un estado, lo añadimos como un parámetro de consulta a la URL.
    // Esto genera una URL como: .../financial-fees/?status=Pending
    if (status != null && status.isNotEmpty) {
      uri = uri.replace(queryParameters: {'status': status});
    }

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['results'];
      return jsonList.map((json) => FinancialFee.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al cargar datos financieros (código: ${response.statusCode})');
    }
  }
}
