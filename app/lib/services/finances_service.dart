// En: app/lib/services/finances_service.dart (Reemplazar todo el contenido)

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/auth_service.dart';
import 'package:app/models/payment_model.dart';
// ¡NO OLVIDES ESTA IMPORTACIÓN QUE TAMBIÉN ES NECESARIA!
import 'package:flutter/foundation.dart';

class FinancesService {
  final String _baseUrl =
      'https://smart-condominium-backend.onrender.com/api/administration';
  final AuthService _authService = AuthService();

  Future<List<FinancialFee>> getFinancialFees() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Usuario no autenticado');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/financial-fees/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      String source = const Utf8Decoder().convert(response.bodyBytes);
      final List<dynamic> data = json.decode(source);
      return data.map((json) => FinancialFee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load financial fees');
    }
  }

  // *** MÉTODO AÑADIDO QUE FALTABA ***
  Future<String> initiatePayment(int feeId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Usuario no autenticado.');

    final response = await http.post(
      Uri.parse('$_baseUrl/payments/initiate_payment/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'financial_fee_id': feeId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['payment_url']; // Devuelve la URL de pago
    } else {
      try {
        final error = jsonDecode(response.body)['error'];
        throw Exception('Error al iniciar el pago: $error');
      } catch (e) {
        throw Exception(
            'Error desconocido al iniciar el pago. Código: ${response.statusCode}');
      }
    }
  }
}
