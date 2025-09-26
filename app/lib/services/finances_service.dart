// app/lib/services/finances_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:app/services/auth_service.dart';
import 'package:app/models/payment_model.dart'; // Importamos nuestro modelo FinancialFee

class FinancesService {
  final String _baseUrl = "http://10.0.2.2:8000/api";
  final AuthService _authService = AuthService();

  /// Obtiene la lista de todas las cuotas financieras del usuario autenticado.
  Future<List<FinancialFee>> getFinancialFees() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Usuario no autenticado. No se puede obtener el token.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/financial-fees/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // La autorización es clave
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      // Usamos el constructor .fromJson que creamos en el modelo FinancialFee
      return jsonList.map((json) => FinancialFee.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los datos financieros.');
    }
  }
}
