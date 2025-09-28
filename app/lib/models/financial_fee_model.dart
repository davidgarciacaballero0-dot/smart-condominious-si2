// lib/models/financial_fee_model.dart

class FinancialFee {
  final int id;
  final String description;
  final double amount;
  final String dueDate;
  final String status;

  FinancialFee({
    required this.id,
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  factory FinancialFee.fromJson(Map<String, dynamic> json) {
    return FinancialFee(
      id: json['id'],
      description: json['description'] ?? 'Sin descripción',
      // Convertimos el monto a double de forma segura
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      dueDate: json['due_date'],
      status: json['status'] ??
          'Desconocido', // El backend envía 'Pending' o 'Paid'
    );
  }
}
