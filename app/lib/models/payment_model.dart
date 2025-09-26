// app/lib/models/payment_model.dart

class FinancialFee {
  final int id;
  final String description;
  final double amount; // Lo manejaremos como un número de doble precisión
  final DateTime dueDate; // Fecha de vencimiento
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
      description: json['description'],
      // El backend envía el monto como un String (ej: "150.00").
      // double.parse() lo convierte a un número que Dart puede usar para cálculos.
      amount: double.parse(json['amount']),
      // Mapeamos 'due_date' del JSON y lo convertimos a DateTime.
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'],
    );
  }
}
