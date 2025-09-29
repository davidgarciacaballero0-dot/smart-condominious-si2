// lib/services/finances_service.dart
import 'package:dio/dio.dart';
import '../models/financial_fee_model.dart';
import 'api_client.dart';

class FinancesService {
  final Dio _dio = ApiClient().dio;

  // Obtener la lista de todas las cuotas (pendientes y pagadas)
  Future<List<FinancialFee>> getMyFinancialFees() async {
    try {
      final response =
          await _dio.get('/administration/financial-fees/my_fees/');
      return (response.data as List)
          .map((feeJson) => FinancialFee.fromJson(feeJson))
          .toList();
    } catch (e) {
      print('Error fetching financial fees: $e');
      return [];
    }
  }

  // --- NUEVO MÉTODO PARA INICIAR EL PAGO ---
  // Llama al backend para crear una sesión de pago en Stripe y obtener la URL
  Future<String?> initiatePayment(int feeId) async {
    try {
      final response = await _dio.post(
        '/administration/financial-fees/$feeId/initiate_payment/',
      );
      // El backend devuelve un JSON con la clave 'checkout_url'
      if (response.data != null && response.data['checkout_url'] != null) {
        return response.data['checkout_url'];
      }
      return null;
    } on DioException catch (e) {
      print('Error initiating payment: ${e.response?.data}');
      return null;
    }
  }
}
