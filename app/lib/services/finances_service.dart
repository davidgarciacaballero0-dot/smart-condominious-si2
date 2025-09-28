// lib/services/finances_service.dart
import 'package:dio/dio.dart';
import '../models/financial_fee_model.dart';
import 'api_client.dart';

class FinancesService {
  final Dio _dio = ApiClient().dio;

  // Obtiene la lista de todas las cuotas (pendientes y pagadas) del usuario logueado
  Future<List<FinancialFee>> getMyFinancialFees() async {
    try {
      // Llama al endpoint específico del backend para obtener las cuotas del usuario
      final response =
          await _dio.get('/administration/financial-fees/my_fees/');

      // Convierte la respuesta JSON en una lista de objetos FinancialFee
      return (response.data as List)
          .map((feeJson) => FinancialFee.fromJson(feeJson))
          .toList();
    } catch (e) {
      // Si hay un error, lo imprimimos en la consola y devolvemos una lista vacía
      print('Error fetching financial fees: $e');
      return [];
    }
  }
}
