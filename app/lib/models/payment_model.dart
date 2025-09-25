enum PaymentStatus { pagado, pendiente, vencido }

class Payment {
  final int id;
  final String concept;
  final double amount;
  final DateTime dueDate;
  final PaymentStatus status;
  // 1. AÑADIMOS EL NUEVO CAMPO (puede ser nulo)
  final DateTime? paymentDate;

  const Payment({
    required this.id,
    required this.concept,
    required this.amount,
    required this.dueDate,
    required this.status,
    // 2. AÑADIMOS EL CAMPO AL CONSTRUCTOR
    this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      concept: json['concept'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      dueDate: DateTime.parse(json['due_date']),
      status: _statusFromString(json['status']),
      // 3. LO PROCESAMOS SI VIENE DEL JSON (y si no, es nulo)
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : null,
    );
  }
}

PaymentStatus _statusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'paid':
      return PaymentStatus.pagado;
    case 'pending':
      return PaymentStatus.pendiente;
    case 'overdue':
      return PaymentStatus.vencido;
    default:
      return PaymentStatus.pendiente;
  }
}
